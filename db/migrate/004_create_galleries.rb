class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections, :force => true do |t|
      t.column "topic_id", :integer
      t.column "thumbnail_id", :integer
      t.column "released", :integer
      t.column "user_id", :integer
      t.column "created_at", :timestamp, :default => '0000-00-00 00:00:00'
      t.column "uploaded_at", :timestamp, :default => '0000-00-00 00:00:00'
      t.column "title", :string
      t.column "description", :text
    end
  end

  def self.down
    drop_table :collections
  end
end
