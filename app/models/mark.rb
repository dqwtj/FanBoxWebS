class Mark < ActiveRecord::Base
  
  belongs_to :idol
  belongs_to :card
  
  before_create :add_idol_name
  def add_idol_name
    self.name = self.idol ? self.idol.name : "#"
  end
  
end