class User < ActiveRecord::Base
  validates :name, :mobile, :encrypted_password, presence: true
  validates :mobile, :name, uniqueness: true
  has_many :cards
  has_one :box
  has_and_belongs_to_many :boxes
  
  # 重新生成 Private Token
  def update_private_token
    random_key = "#{SecureRandom.hex(10)}:#{self.id}"
    self.update(private_token: random_key)
    self.private_token
  end
  
  after_create :create_user_box
  def create_user_box
    self.create_box(name: self.name, user_box: true)
  end
  
end