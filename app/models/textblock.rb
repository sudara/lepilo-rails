class Textblock < ActiveRecord::Base
  validates_presence_of   :content
  has_many :block_links, :order => :position, :as => :linked, :dependent => :destroy
  
end
