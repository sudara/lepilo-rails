class Topic < ActiveRecord::Base
  belongs_to :topic
  has_many :topics, :order => :position
  has_one :article
  acts_as_tree  :order => :position, :foreign_key => 'topic_id'  
  acts_as_list  :scope => :topic_id  
  
  validates_presence_of :topic_id
  
  before_create :set_name
  
  #attr_accessor :level
  
  def level
    if !self.parent 
      return 1
    else 
      return 1 + self.parent.level 
    end
  end
  
  
  def self.root
    if Topic.count == 0
      root = Topic.new(:title=>"root").save_with_validation(false)
      root.id
    else 
      Topic.find_by_topic_id(nil)
    end
  end
  
  protected
  
  def set_name
    self.title = "New Page" unless self.title
  end
end
