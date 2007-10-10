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

  before_filter :configure_charsets, :ensure_default_tabs, :simple_layout?
  
  # TODO: Make sure this is only called when needed
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
      add_lepilo_tab 'overview.png',          settings_path
      add_lepilo_tab 'navigation.png',        topics_path  
      add_lepilo_tab 'articles.png',          articles_path 
      add_lepilo_tab 'collections.png',       '/collections' 
      add_lepilo_tab 'textblocks.png',        textblocks_path
      add_lepilo_tab 'media.png',             mediablocks_path

      add_lepilo_admin_tab 'accounts.png',    users_path
    end
  end
  
  # TODO: catch the error if the db is emtpy
  # rescue  ActiveRecord::StatementInvalid
  
  protected
  
  # layout used for popups and such
  def simple_layout?
    render :layout => 'simple' if params[:simple_layout]
  end
end