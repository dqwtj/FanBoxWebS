require 'spec_helper'

describe API, "cards", :type => :request do
  include Rack::Test::Methods
  
  def app
    API
  end
  
  describe "POST /dev/cards" do
    
    it "return success message" do
      
      user = create(:user)
      card = build(:card)
      
      post "/dev/cards", :token => user.private_token, :title => card.title, :height => card.height, :base_url => card.base_url
      
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      user.reload
      expect(user.cards_count).to eq( 1 )
      expect(Card.last.img_preview_url).to eq( "#" )
      
    end
    
  end
  
  describe "DELETE /dev/cards/:id" do
    
    it "return success message" do
      
      user = create(:user_with_cards, cards_count: 5)
      card = user.cards.last
      
      delete "/dev/cards/"+card.card_id, :token => user.private_token
      
      expect(last_response.status).to eq(200)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      user.reload
      expect(user.cards_count).to eq( 4 )
      
      
    end
    
  end
  
  describe "POST /dev/cards/:id/report" do
    
    it "return success message" do
      
      user = create(:user_with_cards, cards_count: 5)
      card = create(:card)
      
      post "/dev/cards/"+card.card_id+"/report", :token => user.private_token, :msg => "非法内容"
      
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      
    end
    
  end
  
  describe "POST /dev/cards/:id/favorite" do
    
    it "return success message" do
      
      user = create(:user_with_cards, cards_count: 5)
      card1 = create(:card)
      card2 = create(:card)
      
      expect(user.favorites_list.size).to eq(0)
      
      post "/dev/cards/"+card1.card_id+"/favorite", :token => user.private_token
      user.reload
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(user.favorites_list.size).to eq(1)
      
      post "/dev/cards/"+card2.card_id+"/favorite", :token => user.private_token
      user.reload
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(user.favorites_list.size).to eq(2)
      
      post "/dev/cards/"+card2.card_id+"/favorite", :token => user.private_token
      user.reload
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(user.favorites_list.size).to eq(2)
      
      
    end
    
  end
  
  describe "POST /dev/cards/:id/unfavorite" do
    
    it "return success message" do
      
      user = create(:user_with_cards, cards_count: 5)
      card1 = create(:card)
      card2 = create(:card)
      card3 = create(:card)
      user.add_favorite(card1.card_id)
      user.add_favorite(card2.card_id)
      
      expect(user.favorites_list.size).to eq(2)
      
      post "/dev/cards/"+card3.card_id+"/unfavorite", :token => user.private_token
      user.reload
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(user.favorites_list.size).to eq(2)
      
      post "/dev/cards/"+card2.card_id+"/unfavorite", :token => user.private_token
      user.reload
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(user.favorites_list.size).to eq(1)
      
      post "/dev/cards/"+card1.card_id+"/unfavorite", :token => user.private_token
      user.reload
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(user.favorites_list.size).to eq(0)
      
      post "/dev/cards/"+card1.card_id+"/unfavorite", :token => user.private_token
      user.reload
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(user.favorites_list.size).to eq(0)
      
      
    end
    
  end
  
  describe "POST /dev/card/:id/tag" do
    
    it "tag one or more box, return success message" do
      
      box1 = create(:box_with_cards, cards_count: 5)
      card = create(:card)
      user = create(:user)

      post "/dev/cards/"+card.card_id+"/tag", :token => user.private_token, :box_ids => [box1.box_id]
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(card.boxes.count).to eq(1)
      

      box2 = create(:box)
      box3 = create(:box)
      box4 = create(:box)
      
      post "/dev/cards/"+card.card_id+"/tag", :token => user.private_token, :box_ids => [box2.box_id, box3.box_id, box4.box_id]
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(card.boxes.count).to eq(4)
      
      post "/dev/cards/"+card.card_id+"/tag", :token => user.private_token, :box_ids => [box2.box_id, box3.box_id]
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(card.boxes.count).to eq(4)
      
      
    end
    
  end
  
  describe "POST /dev/card/:id/mark" do
    
    it "mark one or more idol, return success message" do
      
      idol1 = create(:idol_with_cards, cards_count: 5)
      card = create(:card)
      user = create(:user)

      post "/dev/cards/"+card.card_id+"/mark", :token => user.private_token, :idol_ids => [idol1.idol_id]
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(card.idols.count).to eq(1)
      

      idol2 = create(:idol)
      idol3 = create(:idol)
      idol4 = create(:idol)
      
      post "/dev/cards/"+card.card_id+"/mark", :token => user.private_token, :idol_ids => [idol2.idol_id, idol4.idol_id]
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(card.idols.count).to eq(3)
      
      post "/dev/cards/"+card.card_id+"/mark", :token => user.private_token, :idol_ids => [idol3.idol_id, idol4.idol_id]
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      expect(card.idols.count).to eq(4)
      
    end
    
  end
  
  describe "POST /dev/card/:id/zan" do
    
    it "return success message" do
      
      user = create(:user)
      card = create(:card)
      
      post "/dev/cards/"+card.card_id+"/zan", :token => user.private_token
      
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      user.reload
      expect(user.zans.count).to eq(1)
      card.reload
      expect(card.zans_count).to eq(1)
      
      post "/dev/cards/"+card.card_id+"/zan", :token => user.private_token
      
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      user.reload
      expect(user.zans.count).to eq(1)
      card.reload
      expect(card.zans_count).to eq(1)

      
    end
    
  end
  
  describe "POST /dev/card/:id/unzan" do
    
    it "return success message" do
      
      user = create(:user)
      card1 = create(:card)
      card2 = create(:card)
      user.zans << card1
      Card.increment_counter(:zans_count, card1.id)
      
      post "/dev/cards/"+card2.card_id+"/unzan", :token => user.private_token
      
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      user.reload
      expect(user.zans.count).to eq(1)
      card1.reload
      expect(card1.zans_count).to eq(1)
      
      post "/dev/cards/"+card1.card_id+"/unzan", :token => user.private_token
      
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      user.reload
      expect(user.zans.count).to eq(0)
      card1.reload
      expect(card1.zans_count).to eq(0)
      
      post "/dev/cards/"+card1.card_id+"/unzan", :token => user.private_token
      
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json["result"]).to eq("1")
      user.reload
      expect(user.zans.count).to eq(0)
      card1.reload
      expect(card1.zans_count).to eq(0)
      
    end
    
  end
  
end