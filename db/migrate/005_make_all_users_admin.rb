class MakeAllUsersAdmin < ActiveRecord::Migration
  def self.up
    User.find(:all).each do |user|
      user.admin = true
      user.save!
    end
  end

  def self.down
  end
end
