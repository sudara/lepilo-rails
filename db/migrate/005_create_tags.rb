class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags, :force => true do |t|
      t.column "name", :string
    end
  end

  def self.down
    drop_table :tags
  end
end
