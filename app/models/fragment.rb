class Fragment < ActiveRecord::Base
  belongs_to :article
  has_many :block_links, :order => :position
  acts_as_list :scope => :article_id

  def after_create
#    fragmentBlock = BlockLink.new
#    fragmentBlock.fragment_id = self.id
#    fragmentBlock.save
  end

end
