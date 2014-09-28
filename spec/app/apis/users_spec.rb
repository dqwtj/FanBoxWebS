require 'spec_helper'

describe API, "users", :type => :request do
  include Rack::Test::Methods
  
  def app
    API
  end
  
  describe "POST /dev/users/sign_up" do
    it "returns an private token" do
      user = build(:user)
      post "/dev/users/sign_up", :name => user.name, :mobile => user.mobile, :password => user.encrypted_password
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["token"]).to eq(User.first.private_token)
    end
    
  end
  
  describe "POST /dev/users/sign_in" do
    it "sign in with mobile, returns an private token" do
      user = create(:user)
      post "/dev/users/sign_in", :mobile => user.mobile, :password => user.encrypted_password
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      user.reload
      expect(json["token"]).to eq(user.private_token)
    end
  end
  
  describe "POST /dev/users/weibo_sign_in" do
    it "sign in with weibo, returns an private token" do
      user = create(:user, weibo_uid: 1234)
      post "/dev/users/weibo_sign_in", :uid => 1234
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      user.reload
      expect(json["token"]).to eq(user.private_token)
    end
  end
  
  describe "POST /dev/users/weibo_unband" do
    
    it "return success message" do
      user = create(:user, weibo_uid: 1234)
      post "/dev/users/weibo_unband", :uid => 1234
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      user.reload
      expect(user.weibo_uid).to eq(nil)
      expect(json["result"]).to eq("1")
    end
    
  end
  
  describe "GET /dev/users/profile" do
    
    it "return user profile info" do
      
      user = create(:user_with_cards, cards_count: 10)
      card = create(:card)
      user.followees << create_list(:user, 10)
      user.zans << card
      user.add_favorite(card.card_id)
      get "/dev/users/profile", :token => user.private_token
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["userId"]).to eq(user.user_id)
      expect(json["avatarUrl"]).to eq(user.avatar_url)
      expect(json["info"]).to eq(user.info)
      expect(json["address"]).to eq(user.address)
      expect(json["gender"]).to eq(user.gender)
      expect(json["cardsIds"].size).to eq(10)
      expect(json["zansIds"].size).to eq(1)
      expect(json["favoritesIds"].size).to eq(1)
      expect(json["followeesIds"].size).to eq(10)
    end
    
  end
  
  describe "PUT /dev/users/profile" do
    
    it "return success message" do
      user = create(:user)
      put "/dev/users/profile", :token => user.private_token, :info => "我改啦", :gender => "女"
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      user.reload
      expect(user.gender).to eq("女")
      expect(user.info).to eq("我改啦")
    end
    
  end
  
  describe "GET /dev/users/:id" do
    
    it "return user info" do
      cuser = create(:user)
      user = create(:user_with_cards, cards_count: 13)
      
      get "/dev/users/"+user.user_id, :token => cuser.private_token
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["totalCount"]).to eq("13")
      expect(json["cards"].size).to eq(10)
      
      get "/dev/users/"+user.user_id, :token => cuser.private_token, :page => 2
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["totalCount"]).to eq("13")
      expect(json["cards"].size).to eq(3)
      
    end
    
  end
  
  describe "POST /dev/users/:id/follow" do
    it "return success message" do
      cuser = create(:user)
      user = create(:user)
      post "/dev/users/"+user.user_id+"/follow", :token => cuser.private_token
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(user.followers.count).to eq(1)
      expect(cuser.followees.count).to eq(1)
      
      post "/dev/users/"+user.user_id+"/follow", :token => cuser.private_token
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(user.followers.count).to eq(1)
      expect(cuser.followees.count).to eq(1)
      
    end
  end
  
  describe "POST /dev/users/:id/unfollow" do
    it "return success message" do
      cuser = create(:user)
      user1 = create(:user)
      user2 = create(:user)
      cuser.followees << user1
      post "/dev/users/"+user2.user_id+"/unfollow", :token => cuser.private_token
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(user1.followers.count).to eq(1)
      expect(user2.followers.count).to eq(0)
      expect(cuser.followees.count).to eq(1)
      
      
      post "/dev/users/"+user1.user_id+"/unfollow", :token => cuser.private_token
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(user1.followers.count).to eq(0)
      expect(user2.followers.count).to eq(0)
      expect(cuser.followees.count).to eq(0)
      
      post "/dev/users/"+user1.user_id+"/unfollow", :token => cuser.private_token
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(user1.followers.count).to eq(0)
      expect(user2.followers.count).to eq(0)
      expect(cuser.followees.count).to eq(0)
      
    end
  end
  

end