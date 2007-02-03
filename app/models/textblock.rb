class Textblock < ActiveRecord::Base
  validates_presence_of   :content
  has_and_belongs_to_many :block_links
  
  def after_destroy
    @blocks = BlockLink.find_all_by_textblock_id(self.id)
    for block in @blocks
      block.destroy
    end
  end

end
