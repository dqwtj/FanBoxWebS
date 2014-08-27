class CreateSubscribes < ActiveRecord::Migration
  
  def change
    
    create_table :subscribes, id: false do |t|
      
      t.belongs_to :user
      t.belongs_to :box
      
    end
    
  end
  
end