class CreateCards < ActiveRecord::Migration
  
  def change
    create_table :cards do |t|
      t.string :title
      t.integer :height
      t.integer :favorites_count
      t.string :image_url
      t.string :preview_image_url
      t.integer :user_id
      
      t.timestamps
    end
  end
  
end