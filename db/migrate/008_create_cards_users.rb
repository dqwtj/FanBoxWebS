class CreateCardsUsers < ActiveRecord::Migration
  
  def change
    
    create_table :cards_users, id: false do |t|
      
      t.belongs_to :card
      t.belongs_to :user
      
    end
    
  end
  
end