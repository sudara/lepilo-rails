class Article < ActiveRecord::Base
  belongs_to :topic
  has_many :fragments, :order => :position
  has_and_belongs_to_many :tags
  
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
    media_counter = BlockLink.count(:all, :conditions => "mediablock_id AND fragment_id = #{self.fragments.first.id}")
    return media_counter
  end


  def count_text
    text_counter = BlockLink.count(:all, :conditions => "textblock_id AND fragment_id = #{self.fragments.first.id}")
    return text_counter
  end

  
  def after_destroy
    @blocks = BlockLink.find_all_by_article_id(self.id)
    for block in @blocks
      block.destroy
    end

    @fragments = Fragment.find_all_by_article_id(self.id)
    for fragment in @fragments
      fragment.destroy
    end
  end
  
end
