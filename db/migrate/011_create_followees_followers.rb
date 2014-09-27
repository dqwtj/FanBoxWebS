class CreateFolloweesFollowers < ActiveRecord::Migration
  
  def change
    
    create_table :followees_followers, id: false do |t|
      
      t.belongs_to :follower
      t.belongs_to :followee
            
    end
    
  end
  
end