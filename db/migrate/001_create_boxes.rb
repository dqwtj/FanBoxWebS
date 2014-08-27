class CreateBoxes < ActiveRecord::Migration
  
  def change
    create_table :boxes do |t|
      t.string :name
      t.text :info
      t.belongs_to :user
      t.belongs_to :idol
      t.integer :subscribes_count
      t.integer :hit_count, default: 0
      t.string :box_type, default: "tag"
      
      t.timestamps
    end
  end
  
end