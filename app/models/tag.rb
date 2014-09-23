class Tag < ActiveRecord::Base
  
  belongs_to :box, counter_cache: true
  belongs_to :card
  
  before_create :add_box_name
  def add_box_name
    self.name = self.box ? self.box.name : "#"
  end
  
end