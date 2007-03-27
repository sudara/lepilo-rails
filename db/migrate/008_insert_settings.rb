class InsertSettings < ActiveRecord::Migration
  def self.up
    Setting.create :setting_id => 0, :key => 'site', :value => 'dina4', :description => 'Seite fuer das Architekturbuero din-a4 in Innsbruck.'
    Setting.create :setting_id => 1, :key => 'FTP', :value => '192.168.1.4', :description => 'Die Adresse des FTP Hosts.'
    Setting.create :setting_id => 2, :key => 'username', :value => 'wgftp', :description => 'Der FTP User.'
    Setting.create :setting_id => 2, :key => 'password', :value => 'wgftp', :description => 'Das Passwort.'
  end

  def self.down
    Setting.find_by_key('site').destroy
    Setting.find_by_key('FTP').destroy
    Setting.find_by_key('username').destroy
    Setting.find_by_key('password').destroy
  end
end
