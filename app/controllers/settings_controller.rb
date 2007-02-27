class SettingsController < ApplicationController
  def index
    
  end
  def ftpupload
    @my_sett = Setting.find_by_key('FTP')
    un = @my_sett.settings.find_by_key('username').value
    pw = @my_sett.settings.find_by_key('password').value
    ftp = Net::FTP.new(@my_sett.value)
    ftp.login(un, pw)
    ftp.chdir('/test/')
    #ftp.putbinaryfile("#{RAILS_ROOT}/public/projekte.xml")
    flash[:notice] = 'FTP Upload abgeschlossen'
    redirect_to :action => 'index'
  end
end
