class CreateIdols < ActiveRecord::Migration
  
  def change
    create_table :idols do |t|
      t.string :name
      t.text :info
      t.string :avatar_url
      t.string :weibo_uid
      t.string :weibo_name
      t.string :topics, default: "官图,新闻,现场,专场,机场,综艺,私生,其它,"
      t.integer :fans_count, default: 0
      t.integer :marks_count, default: 0
      
      t.timestamps
    end
  end
  
end