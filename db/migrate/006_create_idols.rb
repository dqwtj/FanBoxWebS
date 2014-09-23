class CreateIdols < ActiveRecord::Migration
  
  def change
    create_table :idols do |t|
      t.string :name
      t.text :info
      t.string :avatar_url
      t.string :weibo_uid
      t.string :weibo_name
      t.integer :fans_count, default: 0
      t.integer :marks_count, default: 0
      
      t.timestamps
    end
  end
  
end