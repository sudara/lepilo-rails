class Setting < ActiveRecord::Base
  belongs_to :setting
  has_many :settings
  
  acts_as_tree  :order => :id, :foreign_key => 'setting_id'  
  acts_as_list  :scope => :setting_id
  
  
  
end
