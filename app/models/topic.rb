class Topic < ActiveRecord::Base
  belongs_to :topic
  has_many :topics, :order => :position
  has_one :article
  acts_as_tree  :order => :position, :foreign_key => 'topic_id'  
  acts_as_list  :scope => :topic_id  
  
  attr_accessor :level
    
end
