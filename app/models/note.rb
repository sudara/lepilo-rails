class Note < ActiveRecord::Base
  has_many :block_links, :order => :position, :as => :linked
end
