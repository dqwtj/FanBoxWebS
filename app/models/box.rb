class Box < ActiveRecord::Base
  
  validates :name, :presence => true
  validates :name, uniqueness: true
  belongs_to :user
  belongs_to :idol
  has_many :tags
  has_many :cards, through: :tags
  has_many :subscribes
  has_many :users, through: :subscribes
  has_and_belongs_to_many :idols
  
end