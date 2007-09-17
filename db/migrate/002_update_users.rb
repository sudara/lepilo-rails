class UpdateUsers < ActiveRecord::Migration
  def self.up
   add_column :users, :crypted_password,          :string, :limit => 40
   add_column :users, :salt,                      :string, :limit => 40
   add_column :users, :updated_at,                :datetime
   add_column :users, :remember_token,            :string
   add_column :users, :remember_token_expires_at, :datetime
  end

  def self.down
    drop_table "users"
  end
end
