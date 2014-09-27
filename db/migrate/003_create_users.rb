class CreateUsers < ActiveRecord::Migration
  
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :mobile
      t.string :encrypted_password
      t.string :private_token
      t.string :weibo_uid
      t.text :info
      t.string :birth_date
      t.string :avatar_url
      t.string :address
      t.string :gender
      t.text :zans
      t.integer :cards_count, default: 0
      
      t.timestamps
    end
  end
  
end