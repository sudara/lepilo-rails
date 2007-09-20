class GiveAllExistingTopicsPermalinks < ActiveRecord::Migration
  def self.up
    # Just saving it will give a permalink
    Topic.find(:all).each do |topic|
      topic.save! unless topic.title = 'root'
    end
  end

  def self.down
  end
end
