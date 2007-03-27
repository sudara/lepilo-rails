# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'login_system'
require 'rand'
require 'redcloth' 
require 'mini_magick'
 
class ApplicationController < ActionController::Base
    include LoginSystem
    model :user
    layout 'lepilo'
    
    before_filter :configure_charsets

    def configure_charsets
      @response.headers["Content-Type"] = "text/html; charset=utf-8"
      # Set connection charset. MySQL 4.0 doesn't support this so it
      # will throw an error, MySQL 4.1 needs this
          suppress(ActiveRecord::StatementInvalid) do
            ActiveRecord::Base.connection.execute 'SET NAMES UTF8'
          end
     end
end