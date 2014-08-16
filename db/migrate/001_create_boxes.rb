class CreateBoxes < ActiveRecord::Migration
  
  def change
    create_table :boxes do |t|
      t.string :name
      t.text :info
      
      t.timestamps
    end
  end
  
end