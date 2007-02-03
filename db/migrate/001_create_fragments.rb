class CreateFragments < ActiveRecord::Migration
  def self.up
    create_table :fragments do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :fragments
  end
end
