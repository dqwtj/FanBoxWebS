class Subscribe < ActiveRecord::Base
  
  belongs_to :box, counter_cache: true
  belongs_to :user
  
end