require 'spec_helper'

describe API, "boxes", :type => :request do
  include Rack::Test::Methods
  
  def app
    API
  end
  
  describe "GET /dev/boxes/:id" do
    
    it "returns a box info with cards" do
      
      box = create(:box_with_cards, cards_count: 10)
      user = create(:user)
      
      get "/dev/boxes/"+box.box_id, :token => user.private_token
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["totalCount"]).to eq("10")
      expect(json["cards"].size).to eq(3)
      
      get "/dev/boxes/"+box.box_id, :token => user.private_token, :page => 4
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["totalCount"]).to eq("10")
      expect(json["cards"].size).to eq(1)
      
      box.reload
      expect(box.hit_count).to eq(2)
      
    end
    
  end
  
  describe "GET /dev/boxes/:id/touch/:cid" do
    
    it "returns a box info with cards" do
      
      box = create(:box_with_cards, cards_count: 10)
      card = Card.last
      user = create(:user)
      
      get "/dev/boxes/"+box.box_id+"/touch/"+card.card_id, :token => user.private_token
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["totalCount"]).to eq("10")
      expect(json["cards"].size).to eq(3)
      
      get "/dev/boxes/"+box.box_id+"/touch/"+card.card_id, :token => user.private_token, :page => 4
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["totalCount"]).to eq("10")
      expect(json["cards"].size).to eq(1)
      
      tag = card.tags.find_by box_id: box.id
      expect(tag.hit_count).to eq(2)
      
    end
    
  end
  
  describe "POST /dev/boxes/:id/subscribe" do
    
    it "returns success message" do
      
      box = create(:box_with_subscribers, users_count: 5)
      user = create(:user)
      
      post "/dev/boxes/" + box.box_id + "/subscribe", :token => user.private_token
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      box.reload
      expect(box.subscribes_count).to eq( 6 )
    end
    
  end
  
  describe "POST /dev/boxes/:id/unsubscribe" do
    
    it "returns success message" do
    
      box = create(:box_with_subscribers, users_count: 5)
      user = User.last
    
      post "/dev/boxes/" + box.box_id + "/unsubscribe", :token => user.private_token
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      box.reload
      expect(box.subscribes_count).to eq( 4 )
    
    end
    
  end
  
end