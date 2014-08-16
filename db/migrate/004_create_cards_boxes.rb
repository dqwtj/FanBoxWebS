class CreateCardsBoxes < ActiveRecord::Migration
  
  def change
    create_join_table :cards, :boxes do |t|
      t.index :card_id
      t.index :box_id
    end
  end
  
end