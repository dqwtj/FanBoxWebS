class CreateFans < ActiveRecord::Migration
  
  def change
    
    create_table :fans, id: false do |t|
      
      t.belongs_to :user
      t.belongs_to :idol
      
    end
    
  end
  
end