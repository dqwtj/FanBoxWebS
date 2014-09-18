class Card < ActiveRecord::Base
  validates :base_url, :presence => true
  belongs_to :user, counter_cache: true
  has_many :tags
  has_many :boxes, through: :tags
  has_and_belongs_to_many :users
  has_many :marks
  has_many :idols, through: :marks
  
  def img_preview_url
    self.upyun_url+self.base_url+"!preview"
  end
  
  def img_standard_url
    self.upyun_url+self.base_url+"!standard"
  end
  
  def img_small_url
    self.upyun_url+self.base_url+"!small"
  end
  
  def card_id
    (self.id + 1000000000).to_s
  end
  
  def reset_from_base
    items = self.base_url.split('/', 8)
    idol = Idol.where(name: items[3])
    self.idols << idol if idol
    self.topic = items[4]
    self.event = items[5]
    self.source = items[6] 
  end
  
  protected
    def upyun_url
      "http://fanhe-photo.b0.upaiyun.com"
    end
  
end