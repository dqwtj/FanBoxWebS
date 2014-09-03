class Fan < ActiveRecord::Base
  
  belongs_to :idol, counter_cache: true
  belongs_to :user
  
end