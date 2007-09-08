class Article < ActiveRecord::Base
  belongs_to :topic
  has_many :fragments, :order => :position, :dependent => :destroy
  has_many :block_links, :order => :position, :as => :linked
  
  def after_create    
    @articleWebFragment = Fragment.new
    @articleWebFragment.article_id = self.id
    @articleWebFragment.info = "Web page for #{self.title}"
    @articleWebFragment.content = "web"
    @articleWebFragment.save
    @articleWebFragment.update

    @articlePrintFragment = Fragment.new
    @articlePrintFragment.article_id = self.id
    @articlePrintFragment.info = "Print PDF for #{self.title}"
    @articlePrintFragment.content = "print"
    @articlePrintFragment.save
    @articlePrintFragment.update
  end
  
  def count_media
    media_counter = BlockLink.count(:all, :conditions => "linked_type = 'Mediablock' AND fragment_id = #{self.fragments.first.id}")
    return media_counter
  end

  def count_text
    text_counter = BlockLink.count(:all, :conditions => "linked_type = 'Textblock' AND fragment_id = #{self.fragments.first.id}")
    return text_counter
  end  
end
