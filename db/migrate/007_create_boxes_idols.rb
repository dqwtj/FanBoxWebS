class CreateBoxesIdols < ActiveRecord::Migration
  
  def change
    
    create_table :boxes_idols, id: false do |t|
      
      t.belongs_to :idol
      t.belongs_to :box
      
    end
    
  end
  
end