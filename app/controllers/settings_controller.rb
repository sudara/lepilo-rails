require 'net/ftp'

class SettingsController < ApplicationController
  before_filter :login_required
  
  def index
    
  end
  def ftpupload
    @my_sett = Setting.find_by_key('FTP')
    un = @my_sett.settings.find_by_key('username').value
    pw = @my_sett.settings.find_by_key('password').value
    Net::FTP.open(@my_sett.value) do |ftp|
      ftp.login(un, pw)
      #
      writexml
      rfile = "/test/projekte.xml"
      #ftp.delete(rfile)
      ftp.putbinaryfile("#{RAILS_ROOT}/public/projekte.xml", rfile)
      #
      @mediablocks = Mediablock.find(:all, :conditions => "uploaded_at = '0000-00-00 00:00:00'")
      for mediablock in @mediablocks
        ftp.putbinaryfile("#{RAILS_ROOT}/public/data/images/#{mediablock.filename}", "/test/images/#{mediablock.filename}")
        ftp.putbinaryfile("#{RAILS_ROOT}/public/data/thumbnails/#{mediablock.thumbnail}", "/test/thumbnails/#{mediablock.thumbnail}")
        mediablock.uploaded_at = DateTime.now
        mediablock.update
      end
    end
    flash[:notice] = 'FTP Upload abgeschlossen'
    redirect_to :action => 'index'
  end
  def writexml
      @articles = Article.find(:all, :order => 'release_date DESC', :conditions => "released = 1")
      # render :layout => false
      projectsxml = render_to_string :layout => false
      timestamp = Time.now.to_i.to_s
      
      if File.exists?("#{RAILS_ROOT}/public/projekte.xml")
        File.open("#{RAILS_ROOT}/public/data/backups/projekte-#{timestamp}.xml", "wb") do |f|
          f.write( File.read("#{RAILS_ROOT}/public/projekte.xml") )
        end        
      end
      
      File.open("#{RAILS_ROOT}/public/projekte.xml", "wb") do |f|
        f.write( projectsxml )
      end
  
      #redirect_to :action => 'list'
  end
end
