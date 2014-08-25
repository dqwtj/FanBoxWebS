class CreateUsersBoxes < ActiveRecord::Migration
  
  def change
    
    create_table :users_boxes, id: false do |t|
      
      t.belongs_to :user
      t.belongs_to :box
      
    end
    
  end
  
end