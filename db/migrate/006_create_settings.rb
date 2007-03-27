class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings, :force => true do |t|
      t.column "setting_id", :integer, :default => 0
      t.column "position", :integer
      t.column "key", :string
      t.column "value", :string
      t.column "description", :text
    end
  end

  def self.down
    drop_table :settings
  end
end
