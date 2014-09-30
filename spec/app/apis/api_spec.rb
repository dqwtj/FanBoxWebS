require 'spec_helper'

describe API do
  include Rack::Test::Methods
  
  def app
    API
  end
  
  describe "GET /dev/stream" do
    it "returns a list of cards" do
      create_list(:card, 16)
      
      get "/dev/stream"
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["totalCount"]).to eq("16")
      expect(json["data"].size).to eq(10)
      
      get "/dev/stream", :page => 2
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["totalCount"]).to eq("16")
      expect(json["data"].size).to eq(6)
      
    end
  end
  
  describe "GET /dev/stream/home" do
    it "returns a list of cards" do
      user = create(:user)
      idol1 = create(:idol_with_cards, cards_count: 8)
      idol2 = create(:idol_with_cards, cards_count: 8)
      idol3 = create(:idol_with_cards, cards_count: 8)
      user.idols << [idol1, idol2]
      
      get "/dev/stream/home", :token => user.private_token
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["totalCount"]).to eq("16")
      expect(json["data"].size).to eq(10)
      
      get "/dev/stream/home",:token => user.private_token, :page => 2
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["totalCount"]).to eq("16")
      expect(json["data"].size).to eq(6)
      
    end
  end

end