class User < ActiveRecord::Base
  validates :name, :encrypted_password, presence: true
  validates :name, uniqueness: true
  has_one :box, dependent: :nullify
  has_many :cards, dependent: :nullify
  has_many :subscribes, dependent: :destroy
  has_many :boxes, -> { distinct }, through: :subscribes
  has_many :fans, dependent: :destroy
  has_many :idols, -> { distinct }, through: :fans
  has_and_belongs_to_many :zans, -> { uniq }, class_name: "Card"
  has_and_belongs_to_many :followers, -> { uniq }, class_name: "User", foreign_key: "followee_id", join_table: "followees_followers", association_foreign_key: "follower_id"
  has_and_belongs_to_many :followees, -> { uniq }, class_name: "User", foreign_key: "follower_id", join_table: "followees_followers", association_foreign_key: "followee_id"
  
  def user_id
    (self.id + 2000000000).to_s
  end
  
  def add_favorite (value)
    if self.favorites
      self.update(favorites: self.favorites + "," + value) unless self.favorites_list.index(value)
    else
      self.update(favorites: value)
    end
  end
  
  def del_favorite (value)
    if self.favorites && self.favorites_list.index(value)
      list = self.favorites_list
      list.delete(value)
      self.update(favorites: list.join(","))
    end
  end

  def favorites_list
    self.favorites ? self.favorites.split(",") : []
  end
  
  # 重新生成 Private Token
  def update_private_token
    random_key = "#{SecureRandom.hex(10)}:#{self.id}"
    self.update(private_token: random_key)
    self.private_token
  end
  
  after_create :create_user_token
  def create_user_token
    #self.create_box(name: self.name, avatar_url: self.avatar_url, info: self.info, box_type: "user")
    self.update_private_token
  end
  
end