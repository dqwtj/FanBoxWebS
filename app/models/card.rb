class Card < ActiveRecord::Base
  validates :title, :presence => true
  belongs_to :user
  has_many :tags
  has_many :boxes, through: :tags
  has_and_belongs_to_many :users
  
  def img_preview_url
    self.base_url.blank? ? "#" : self.upyun_url+self.base_url+"!preview"
  end
  
  def img_standard_url
    self.base_url.blank? ? "#" : self.upyun_url+self.base_url+"!standard"
  end
  
  def card_id
    (self.id + 1000000000).to_s
  end
  
  protected
    def upyun_url
      "http://fanhe-photo.b0.upaiyun.com"
    end
  
end