# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

# require 'login_system'
require 'rand'
require 'redcloth' 
require 'mini_magick'
 
class ApplicationController < ActionController::Base
  
  include NavigationSystem
  include AuthenticatedSystem
  
  layout 'lepilo'

  before_filter :configure_charsets, :ensure_default_tabs
  
  def configure_charsets
    response.headers["Content-Type"] = "text/html; charset=utf-8"
    # Set connection charset. MySQL 4.0 doesn't support this so it
    # will throw an error, MySQL 4.1 needs this
    suppress(ActiveRecord::StatementInvalid) do
      ActiveRecord::Base.connection.execute 'SET NAMES UTF8'
    end
  end
  
  def ensure_default_tabs
    # hack to protect production mode
    if @@tabs.empty? 
      add_lepilo_tab 'overview.png',          :controller => :settings  
      add_lepilo_tab 'navigation.png',        :controller => :topics    
      add_lepilo_tab 'articles.png',          :controller => :articles  
      add_lepilo_tab 'collections.png',       :controller => :collections  
      add_lepilo_tab 'textblocks.png',        :controller => :textblocks
      add_lepilo_tab 'media.png',             :controller => :mediablocks

      add_lepilo_admin_tab 'accounts.png',    :controller => :users
    end
  end
  
  # TODO: catch the error if the db is emtpy
  # rescue  ActiveRecord::StatementInvalid
end