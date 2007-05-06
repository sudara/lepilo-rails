class Fragment < ActiveRecord::Base
  belongs_to :article
  has_many :block_links, :order => :position
  acts_as_list :scope => :article_id

end
