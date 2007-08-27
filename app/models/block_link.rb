class BlockLink < ActiveRecord::Base
  belongs_to :fragment 
  belongs_to :collection
  belongs_to :linked, :polymorphic => true
  acts_as_list :scope => :fragment_id

end