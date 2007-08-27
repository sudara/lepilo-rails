class Textblock < ActiveRecord::Base
  validates_presence_of   :content
  has_many :block_links, :order => :position, :as => :linked
  
  def after_destroy
    @blocks = BlockLink.find_all_by_textblock_id(self.id)
    for block in @blocks
      block.destroy
    end
  end
end
