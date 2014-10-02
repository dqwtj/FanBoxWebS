class Box < ActiveRecord::Base
  
  validates :name, :presence => true
  has_many :tags
  has_many :cards, through: :tags
  has_many :subscribes
  has_many :users, through: :subscribes
  belongs_to :idol
  
  belongs_to :user
  
  def box_id
    (self.id + 3000000000).to_s
  end
  
  def line_1
    self.line ? self.line.splite("|",2)[0] : "######"
  end
  
  def line_2
    self.line ? self.line.splite("|",2)[1] : "XOXOXOXOXO"
  end
  
end