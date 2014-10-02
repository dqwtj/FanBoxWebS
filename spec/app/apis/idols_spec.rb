require 'spec_helper'

describe API, "idols", :type => :request do
  include Rack::Test::Methods
  
  def app
    API
  end
  
  describe "GET /dev/idols/:id" do
    
    it "returns an idol info with cards" do
      
      idol = create(:idol_with_cards, cards_count: 11)
      user = create(:user)
      
      get "/dev/idols/"+idol.idol_id, :token => user.private_token
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["totalCount"]).to eq("11")
      expect(json["cards"].size).to eq(10)
      
      get "/dev/idols/"+idol.idol_id, :token => user.private_token, :page => 2
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["totalCount"]).to eq("11")
      expect(json["cards"].size).to eq(1)
      
    end
    
  end
  
  describe "POST /dev/idols/:id/fan" do
    
    it "returns success message" do
      
      idol = create(:idol_with_fans, fans_count: 10)
      user = create(:user)
      
      post "/dev/idols/" + idol.idol_id + "/fan", :token => user.private_token
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      idol.reload
      expect(idol.fans_count).to eq( 11 )
      
    end
    
  end
  
  describe "GET /dev/idols/:id/hot_boxes" do
    
    it "returns a list of hot boxes" do
      
      idol = create(:idol)
      user = create(:user)
      idol.boxes << create(:box, hit_count: 123)
      idol.boxes << create(:box, hit_count: 112)
      idol.boxes << create(:box, hit_count: 68)
      idol.boxes << create(:box, hit_count: 23)
      
      get "/dev/idols/" + idol.idol_id + "/hot_boxes", :token => user.private_token
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["boxes"].size).to eq(10)
      expect(json["boxes"][0]["hitCount"]).to eq(123)
      expect(json["boxes"][3]["hitCount"]).to eq(23)
    end
    
  end
  
  describe "GET /dev/idols/:id/nine" do
    
    it "returns a list of topic boxes" do
      
      idol = create(:idol)
      user = create(:user)
      
      get "/dev/idols/" + idol.idol_id + "/nine", :token => user.private_token
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["totalCount"]).to eq("8")
      expect(json["nines"].size).to eq(8)
      
    end
    
  end
  
end