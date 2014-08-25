class CreateTags < ActiveRecord::Migration
  
  def change
    create_table :tags do |t|
      
      t.belongs_to :box
      t.belongs_to :card
      t.string :name
      t.integer :hit_count, default: 0
      
      t.index :card_id
      t.index :box_id
      
      t.timestamps
    end
  end
  
end