class Idol < ActiveRecord::Base
  
  validates :name, :presence => true
  has_and_belongs_to_many :boxes
  has_many :fans
  has_many :users, through: :fans
  has_many :marks
  has_many :cards, through: :marks
  
  def idol_id
    (self.id + 4000000000).to_s
  end
  
end