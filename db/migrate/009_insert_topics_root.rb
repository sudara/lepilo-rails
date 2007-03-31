class InsertTopicsRoot < ActiveRecord::Migration
  def self.up
    Topic.create :id => 1, :position => 1, :title => 'root', :description => 'Webpage root'
  end

  def self.down
    Topic.find_by_title('root').destroy
  end
end
