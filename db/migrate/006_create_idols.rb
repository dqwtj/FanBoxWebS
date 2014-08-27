class CreateIdols < ActiveRecord::Migration
  
  def change
    create_table :idols do |t|
      t.string :name
      t.text :info
      t.string :avatar_url
      t.string :weibo_url
      
      t.timestamps
    end
  end
  
end