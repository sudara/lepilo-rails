class CreateMediablockLinks < ActiveRecord::Migration
  def self.up
    create_table :mediablock_links, :force => true do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :mediablock_links
  end
end
