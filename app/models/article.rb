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
    media_counter = 0
    
    if mediablocks = BlockLink.find_all_by_fragment_id(self.fragments.first.id) 
      for block in mediablocks
        if block.mediablock_id
          media_counter = media_counter + 1
        end
      end
    end 
    
    return media_counter
  end


  def count_text
    text_counter = 0
    
    if textblocks = BlockLink.find_all_by_fragment_id(self.fragments.first.id) 
      for block in textblocks
        if block.textblock_id
          text_counter = text_counter + 1
        end
      end
    end 
    
    return text_counter
  end

  
  def after_destroy
    @blocks = BlockLink.find_all_by_article_id(self.id)
    for block in @blocks
      block.destroy
    end
  end
  
end
