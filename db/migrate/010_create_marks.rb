class CreateMarks < ActiveRecord::Migration
  
  def change
    create_table :marks do |t|
      
      t.belongs_to :idol
      t.belongs_to :card
      t.string :name
      t.string :avatar_url
      t.integer :hit_count, default: 0
      t.integer :pos_x, default: 0
      t.integer :pos_y, default: 0
      
      t.index :card_id
      t.index :idol_id
      
      t.timestamps
    end
  end
  
end