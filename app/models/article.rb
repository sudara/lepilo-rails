class Article < ActiveRecord::Base
  has_many :topics
  has_many :fragments, :order => :position, :dependent => :destroy
  has_many :block_links, :order => :position, :as => :linked
  
  after_validation_on_create :publish
  after_create :make_fragments
  
  # Defines how this model will_paginate 
  cattr_reader :per_page 
  @@per_page = 25
  
  def count_media
    media_counter = BlockLink.count(:all, :conditions => "linked_type = 'Mediablock' AND fragment_id = #{self.fragments.first.id}")
    return media_counter
  end

  def count_text
    text_counter = BlockLink.count(:all, :conditions => "linked_type = 'Textblock' AND fragment_id = #{self.fragments.first.id}")
    return text_counter
  end  
  
  def topic
    topics.first
  end
  
  protected 
  
  def publish
    release_date = Date.today
    released = 0
    description = '...' unless description
  end
  
  # OPTIMIZE: Um...so the default right now is to create two fragments upon article create
  def make_fragments
    @articleWebFragment = Fragment.new
    @articleWebFragment.article_id = self.id
    @articleWebFragment.info = "Web page for #{self.title}"
    @articleWebFragment.content = "web"
    @articleWebFragment.save

    @articlePrintFragment = Fragment.new
    @articlePrintFragment.article_id = self.id
    @articlePrintFragment.info = "Print PDF for #{self.title}"
    @articlePrintFragment.content = "print"
    @articlePrintFragment.save
  end
end
