class BlockLink < ActiveRecord::Base
  belongs_to :fragment 
  belongs_to :gallery
  acts_as_list :scope => :fragment_id
end