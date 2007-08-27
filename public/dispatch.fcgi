#!/usr/bin/env ruby
#
# You may specify the path to the FastCGI crash log (a log of unhandled
# exceptions which forced the FastCGI instance to exit, great for debugging)
# and the number of requests to process before running garbage collection.
#
# By default, the FastCGI crash log is RAILS_ROOT/log/fastcgi.crash.log
# and the GC period is nil (turned off).  A reasonable number of requests
# could range from 10-100 depending on the memory footprint of your app.
#
# Example:
#   # Default log path, normal GC behavior.
#   RailsFCGIHandler.process!
#
#   # Default log path, 50 requests between GC.
#   RailsFCGIHandler.process! nil, 50
#
#   # Custom log path, normal GC behavior.
#   RailsFCGIHandler.process! '/var/log/myapp_fcgi_crash.log'
#
require File.dirname(__FILE__) + "/../config/environment"
require 'fcgi_handler'

class RailsFCGIHandler
 private
#   def frao_handler(signal)
#     dispatcher_log :info, "asked to terminate immediately"
#     dispatcher_log :info, "frao handler working its magic!"
#     restart_handler(signal)
#   end
#   alias_method :exit_now_handler, :frao_handler
   
   def busy_exit_handler(signal)
     dispatcher_log :info, "busy: asked to terminate during request signal #{signal}, deferring!"
     @when_ready = :exit
   end

   # Dreamhost sends the term signal and if were handling a request defer it
   def term_process_request(cgi)
     install_signal_handler('TERM',method(:busy_exit_handler).to_proc)
     Dispatcher.dispatch(cgi)
   rescue Exception => e  # errors from CGI dispatch
     raise if SignalException === e
     dispatcher_error(e)
   ensure
     install_signal_handler('TERM', method(:exit_now_handler).to_proc)
   end
   alias_method :process_request, :term_process_request
end

RailsFCGIHandler.process!