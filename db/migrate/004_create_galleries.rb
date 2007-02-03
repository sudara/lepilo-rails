class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :galleries
  end
end
