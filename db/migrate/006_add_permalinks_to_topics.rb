class AddPermalinksToTopics < ActiveRecord::Migration
  def self.up
    add_column  :topics, :permalink, :string
  end

  def self.down
    remove_column :topics, :permalink
  end
end
