class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :boxes_idols, :idol_id
    add_index :boxes_idols, [:idol_id, :box_id]
    add_index :boxes_idols, [:box_id, :idol_id]
    add_index :boxes_idols, :box_id
    add_index :cards_users, :card_id
    add_index :cards_users, :user_id
    add_index :cards_users, [:user_id, :card_id]
    add_index :fans, :idol_id
    add_index :fans, :user_id
    add_index :fans, [:idol_id, :user_id]
    add_index :cards, :user_id
    add_index :subscribes, :box_id
    add_index :subscribes, :user_id
  end
end