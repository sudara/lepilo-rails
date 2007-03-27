class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings, :force => true do |t|
      t.column "setting_id", :integer, :default => 0
      t.column "key", :string
      t.column "value", :string
      t.column "description", :text
    end
    
    #Setting.create :setting_id => 0, :key => 'site', :value => 'dina4', :description => 'Seite fuer das Architekturbuero din-a4 in Innsbruck.'
    #Setting.create :setting_id => 1, :key => 'FTP', :value => '192.168.1.4', :description => 'Die Adresse des FTP Hosts.'
    #Setting.create :setting_id => 2, :key => 'username', :value => 'wgftp', :description => 'Der FTP User.'
    #Setting.create :setting_id => 2, :key => 'password', :value => 'wgftp', :description => 'Das Passwort.'
  end

  def self.down
    drop_table :settings
  end
end
