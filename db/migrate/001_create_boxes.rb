class CreateBoxes < ActiveRecord::Migration
  
  def change
    create_table :boxes do |t|
      t.string :name
      t.text :info
      t.string :avatar_url      
      t.integer :subscribes_count, default: 0
      t.integer :hit_count, default: 0
      t.string :box_type, default: "tag"
      t.integer :tags_count, default: 0
      
      t.timestamps
    end
  end
  
end