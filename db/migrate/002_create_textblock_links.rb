class CreateTextblockLinks < ActiveRecord::Migration
  def self.up
    create_table :textblock_links do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :textblock_links
  end
end
