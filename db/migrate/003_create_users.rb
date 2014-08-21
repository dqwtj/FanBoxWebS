class CreateUsers < ActiveRecord::Migration
  
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :mobile
      t.string :encrypted_password
      t.string :private_token
      t.text :info
      t.string :avatar_url
      
      t.timestamps
    end
  end
  
end