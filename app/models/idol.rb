class Idol < ActiveRecord::Base
  
  validates :name, :presence => true
  has_many :fans
  has_many :users, through: :fans
  has_many :marks
  has_many :cards, through: :marks
  has_many :boxes
  
  def idol_id
    (self.id + 4000000000).to_s
  end
  
  def topics_list
    self.topics.split(",")
  end
  
  after_create :create_topic_boxes
  def create_topic_boxes
    self.topics_list.each do |topic|
      self.boxes.create(name: topic, box_type: "topic")
    end
  end
  
end