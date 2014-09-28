class Mark < ActiveRecord::Base
  
  belongs_to :idol, counter_cache: true
  belongs_to :card
  
  before_create :add_idol_name
  def add_idol_name
    self.name = self.idol ? self.idol.name : "#"
    self.avatar_url = self.idol ? self.idol.avatar_url : "#"
  end
  
end