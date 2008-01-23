require 'fcgi_handler'

class RailsFCGIHandler
 # Dreamhost: changes TERM signal handling so your site isn't killed while handling a request
 private
   def busy_exit_handler(signal)
     dispatcher_log :info, "busy: asked to terminate during request signal #{signal}, deferring!"
     @when_ready = :exit
   end

   def term_process_request(cgi)
     install_signal_handler('TERM',method(:busy_exit_handler).to_proc)
     Dispatcher.dispatch(cgi)
   rescue Exception => e
     raise if SignalException === e
     dispatcher_error(e)
   ensure
     install_signal_handler('TERM', method(:exit_now_handler).to_proc)
   end
   alias_method :process_request, :term_process_request
end