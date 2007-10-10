class Textblock < ActiveRecord::Base
  validates_presence_of   :content
  has_many :block_links, :order => :position, :as => :linked, :dependent => :destroy
  
  # Defines how this model will_paginate 
  cattr_reader :per_page 
  @@per_page = 25
  
end
