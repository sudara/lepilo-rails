class Topic < ActiveRecord::Base
  belongs_to :topic
  has_many :topics, :order => :position
  acts_as_tree  :order => :position, :foreign_key => 'topic_id'  
  acts_as_list  :scope => :topic_id  
  
  def self.find_by_title(title)
    topic_id = Topic.find_by_title(title).id
    find(:all, :conditions => ["topic_id = ?", topic_id])
  end 
  
  def self.find_by_topic_id(topic_id)
    find(:all, :conditions => ["topic_id = ?", topic_id])
  end
  
end