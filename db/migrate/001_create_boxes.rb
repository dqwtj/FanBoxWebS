class CreateBoxes < ActiveRecord::Migration
  
  def change
    create_table :boxes do |t|
      t.string :name
      t.text :info
      t.belongs_to :user
      t.integer :hit_count, default: 0
      t.boolean :user_box, default: false
      
      t.timestamps
    end
  end
  
end