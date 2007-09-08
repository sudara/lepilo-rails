class AddFragmentIdToFragment < ActiveRecord::Migration
  def self.up
    add_column :fragments, :fragment_id, :integer
  end

  def self.down
    remove_column :fragments, :fragment_id
  end
end
