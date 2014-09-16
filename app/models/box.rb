class Box < ActiveRecord::Base
  
  validates :name, :presence => true
  validates :name, uniqueness: true
  has_many :tags
  has_many :cards, through: :tags
  has_many :subscribes
  has_many :users, through: :subscribes
  has_and_belongs_to_many :idols
  
  def box_id
    (self.id + 3000000000).to_s
  end
  
end