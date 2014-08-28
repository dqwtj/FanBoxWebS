class User < ActiveRecord::Base
  validates :name, :mobile, :encrypted_password, presence: true
  validates :mobile, :name, uniqueness: true
  has_many :cards
  has_one :box
  has_many :subscribes
  has_many :boxes, through: :subscribes
  has_and_belongs_to_many :favorites, class_name: "Card"
  
  
  def user_id
    (self.id + 2000000000).to_s
  end
  
  # 重新生成 Private Token
  def update_private_token
    random_key = "#{SecureRandom.hex(10)}:#{self.id}"
    self.update(private_token: random_key)
    self.private_token
  end
  
  after_create :create_user_box
  def create_user_box
    self.create_box(name: self.name, box_type: "user")
    # And something more
    self.update_private_token
  end
  
end