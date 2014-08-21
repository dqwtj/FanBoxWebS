class User < ActiveRecord::Base
  validates :name, :mobile, :encrypted_password, presence: true
  validates :mobile, :name, uniqueness: true
  has_many :cards
  
  # 重新生成 Private Token
  def update_private_token
    random_key = "#{SecureRandom.hex(10)}:#{self.id}"
    self.update(private_token: random_key)
    self.private_token
  end
  
end