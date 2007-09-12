class Fragment < ActiveRecord::Base
  belongs_to :article
  has_many :block_links, :order => :position, :dependent => :destroy
  has_many :fragments, :order => :position, :dependent => :destroy
  acts_as_list :scope => :fragment_id

  def after_destroy
    self.block_links.destroy_all
  end
end
