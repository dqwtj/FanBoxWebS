class CreateCards < ActiveRecord::Migration
  
  def change
    create_table :cards do |t|
      t.string :title
      t.string :pack
      t.string :topic
      t.string :event
      t.string :source
      t.string :size
      t.string :image_type
      t.string :image_height
      t.string :image_width
      t.string :c_type
      t.integer :height
      t.integer :favorites_count, default: 0
      t.integer :zans_count, default: 0
      t.string :base_url, limit: 2048
      t.string :preview_url, limit: 2048
      t.string :key_url, limit: 2048
      t.integer :user_id
      
      t.timestamps
    end
  end
  
end