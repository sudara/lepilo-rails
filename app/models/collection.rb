class Collection < ActiveRecord::Base
  has_many :block_links, :order => :position, :as => :linked

  def count_media
    media_counter = 0
    
    mediablocks = BlockLink.find_all_by_collection_id(self.id) 
    
    for block in mediablocks
      if block.linked_type == "Mediablock"
        media_counter = media_counter + 1
      end
    end
    
    return media_counter
  end

  def count_articles
    article_counter = 0
    
    articleblocks = BlockLink.find_all_by_collection_id(self.id) 
    
    for block in articleblocks
      if block.linked_type == "Article"
        article_counter = article_counter + 1
      end
    end
    
    return article_counter
  end  

end
