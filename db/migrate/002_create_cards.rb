class CreateCards < ActiveRecord::Migration
  
  def change
    create_table :cards do |t|
      t.string :title
      t.integer :height
      t.integer :favorites_count, default: 0
      t.string :base_url
      t.integer :user_id
      
      t.timestamps
    end
  end
  
end