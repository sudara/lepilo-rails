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
      rfile = "/htdocs/projekte.xml"
      #ftp.delete(rfile)
      ftp.putbinaryfile("#{RAILS_ROOT}/public/projekte.xml", rfile)
      #
      @mediablocks = Mediablock.find(:all, :conditions => "uploaded_at = '1970-01-01 01:01:00'")
      #breakpoint
      @mediablocks.each do |mediablock|
        ftp.putbinaryfile("#{RAILS_ROOT}/public/data/images/#{mediablock.filename}", "/htdocs/data/images/#{mediablock.filename}")
        ftp.putbinaryfile("#{RAILS_ROOT}/public/data/thumbnails/#{mediablock.thumbnail}", "/htdocs/data/thumbnails/#{mediablock.thumbnail}")
        mediablock.uploaded_at = DateTime.now.to_s(:db)
        mediablock.update
      end
    end
    flash[:ok] = 'FTP Upload abgeschlossen'
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
  
  def changeblocklinks
    @allblocklinks = BlockLink.find(:all)
    blockcounter = 0
    
    @allblocklinks.each do |blocklink|
      unless blocklink.linked
        if blocklink.textblock_id
          @link_to = Textblock.find(blocklink.textblock_id)
        elsif blocklink.mediablock_id
          @link_to = Mediablock.find(blocklink.mediablock_id)
        elsif blocklink.article_id
          @link_to = Article.find(blocklink.article_id)
        end
      
        blocklink.linked = @link_to
        blocklink.save
        blockcounter = blockcounter + 1
      end
    end
    
    flash[:ok] = blockcounter.to_s + ' BlockLinks aktualisiert'
    redirect_to :action => 'index'
  end

  def cleanupblocklinks
    @allblocklinks = BlockLink.find(:all)
    blockcounter = 0
    
    @allblocklinks.each do |blocklink|
        
      if blocklink.fragment_id && !blocklink.fragment
        blocklink.destroy
      end
      
      if blocklink.linked_type == "Textblock"
        if Textblock.find_all_by_id(blocklink.linked_id).empty?          
          blocklink.destroy
        end
      elsif blocklink.linked_type == "Mediablock"
        if !Mediablock.find_all_by_id(blocklink.linked_id).empty?
          blocklink.destroy
        end
      elsif blocklink.linked_type == "Article"
        if !Article.find_all_by_id(blocklink.linked_id).empty?
          blocklink.destroy
        end
      end
    end

    flash[:ok] = blockcounter.to_s + ' BlockLinks aktualisiert'
    redirect_to :action => 'index'
  end
  
end
