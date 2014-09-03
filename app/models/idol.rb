class Idol < ActiveRecord::Base
  
  validates :name, :presence => true
  has_one :box
  has_and_belongs_to_many :boxes
  has_many :fans
  has_many :users, through: :fans
  
  def idol_id
    (self.id + 4000000000).to_s
  end
  
  after_create :create_idol_box
  def create_idol_box
    self.create_box(name: self.name, box_type: "idol")
  end
  
end