class CreateFragments < ActiveRecord::Migration
  def self.up
    create_table :fragments, :force => true do |t|
      t.column "article_id", :integer
      t.column "type", :string
      t.column "position", :integer
      t.column "user_id", :integer
      t.column "created_at", :timestamp, :default => '0000-00-00 00:00:00'
      t.column "updated_at", :timestamp, :default => '0000-00-00 00:00:00'
      t.column "info", :text
    end
  end

  def self.down
    drop_table :fragments
  end
end
