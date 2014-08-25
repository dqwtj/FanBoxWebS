class Card < ActiveRecord::Base
  validates :title, :presence => true
  belongs_to :user
  has_many :tags
  has_many :boxes, through: :tags
  
  def img_preview_url
    self.base_url.blank? ? "#" : self.upyun_url+self.base_url+"!preview"
  end
  
  def img_standard_url
    self.base_url.blank? ? "#" : self.upyun_url+self.base_url+"!standard"
  end
  
  protected
    def upyun_url
      "http://fanhe-photo.b0.upaiyun.com"
    end
  
end