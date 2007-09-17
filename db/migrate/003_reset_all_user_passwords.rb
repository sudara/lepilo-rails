class ResetAllUserPasswords < ActiveRecord::Migration
  def self.up
    ##
    ## Because we are updating the Authentication system to use salts
    ## We must reset each users password ;(
    ##
  
    User.find(:all).each do |user|
      user.password = user.password_confirmation = "123456"
      user.save!
    end
  end

  def self.down
  end
end
