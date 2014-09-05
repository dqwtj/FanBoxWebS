require 'will_paginate'
require 'will_paginate/active_record'

class API < Grape::API
  
  version 'dev', :using => :path
  format :json
  
  helpers do
    def current_user
      token = params[:token]
      @current_user ||= User.where(private_token: token).first
    end
  
    def authenticate!
      error!({ "error" => "401 Unauthorized" }, 401) unless current_user
    end
  end
  
  resources :users do
    
    post "/sign_up" do
      # signature = Digest::MD5.hexdigest(params[:mobile] + '&'+'vuEqnXFYyJnGiiJeI7lbwpmHI0M')
      # error!({ "error" => "401 Unauthorized" }, 401) unless signature = params[:signature]
      error!({ "error" => "404 Creatation Failed", "messange" =>  "Box Name Used" }, 404) if Box.find_by name: params[:name]
      error!({ "error" => "404 Creatation Failed", "messange" =>  "Mobile Number Used" }, 404) if User.find_by mobile: params[:mobile]
      error!({ "error" => "404 Creatation Failed", "messange" =>  "Weibo ID Used" }, 404) if User.find_by weibo_uid: params[:uid]
      user = User.new do |u|
        u.name = params[:name]
        u.mobile = params[:mobile]
        u.encrypted_password = params[:password]
        u.weibo_uid = params[:uid]
      end
      if user.save
        present :token, user.update_private_token
      else
        error!({ "error" => "404 Creatation Failed", "message" => user.errors }, 404)
      end
    end
    
    post "/sign_in" do
      error!({ "error" => "402 Unknow Mobile User" }, 402) unless params[:mobile]
      user = User.find_by mobile: params[:mobile]
      error!({ "error" => "402 Unknow Mobile User" }, 402) unless user
      error!({ "error" => "403 Wrong Password" }, 403) unless user.encrypted_password == params[:password]
      present :token, user.update_private_token
    end
    
    post "/weibo_sign_in" do
      error!({ "error" => "406 Unknow Weibo User" }, 406) unless params[:uid]
      user = User.find_by weibo_uid: params[:uid]
      error!({ "error" => "406 Unknow Weibo User" }, 406) unless user
      present :token, user.update_private_token
    end
    
    post "/weibo_unband" do
      error!({ "error" => "406 Unknow Weibo User" }, 406) unless params[:uid]
      user = User.find_by weibo_uid: params[:uid]
      error!({ "error" => "406 Unknow Weibo User" }, 406) unless user
      if user.mobile
        user.update(weibo_uid: nil)
        { result: "1", message: "success" }
      else
        error!({ "error" => "407 Unband Weibo Failed", "message" => "No Mobile Infomation" }, 407) unless user
      end
    end
    
    get "/profile" do
      authenticate!
      present current_user, with: APIEntities::Profile
    end
    
    put "/profile" do
      authenticate!
      current_user.name = params[:name] if params[:name]
      current_user.email = params[:email] if params[:email]
      current_user.info = params[:info] if params[:info]
      current_user.avatar_url = params[:avatar_url] if params[:avatar_url]
      current_user.address = params[:address] if params[:address]
      current_user.gender = params[:gender] if params[:gender]
      if current_user.save
        { result: "1", message: "success" }
      else
        error!({ "error" => "404 Update Failed", "message" => current_user.errors }, 404)
      end
    end
    
    get "/:id" do
      authenticate!
      user = User.find(params[:id].to_i - 2000000000)
      if user
        present :userInfo, user, with: APIEntities::User
        present :totalCount, user.cards.count.to_s
        present :cards, user.cards.paginate(:page => params[:page], :per_page => 3), with: APIEntities::Card
      else
        error!({ "error" => "408 Unknow User ID" }, 408) unless user
      end
    end
    
  end
  
  namespace :stream do
    
    get do   
      present :totalCount, Card.all.count.to_s
      present :data, Card.all.paginate(:page => params[:page], :per_page => 10), with: APIEntities::Card
    end
    
    get "/home" do
      authenticate!
      b_ids = current_user.boxes.ids
      cards = Card.joins(:tags).where(tags: {box_id: b_ids}).includes(:user, :tags).paginate(:page => params[:page], :per_page => 3)
      present :totalCount, cards.count.to_s
      present :data, cards, with: APIEntities::Card
    end
    
  end
  
  resources :boxes do
    
    post "/:id/subscribe" do
      authenticate!
      box = Box.find(params[:id].to_i - 3000000000)
      error!({ "error" => "405 Unknow Box ID" }, 405) unless box
      current_user.boxes << box
      { result: "1", message: "success" }
    end
    
    post "/:id/unsubscribe" do
      authenticate!
      box = current_user.boxes.find(params[:id].to_i - 3000000000)
      error!({ "error" => "405 Unknow Box ID" }, 405) unless box
      current_user.boxes.delete(box)
      { result: "1", message: "success" }
    end
    
    get "/:id" do
      authenticate!
      box = Box.find(params[:id].to_i - 3000000000)
      error!({ "error" => "405 Unknow Box ID" }, 405) unless box
      
      Box.increment_counter(:hit_count, box.id)
      
      present :boxInfo, box, with: APIEntities::Box
      present :totalCount, box.cards.count.to_s
      present :cards, box.cards.paginate(:page => params[:page], :per_page => 3), with: APIEntities::Card
    end
    
    get "/:id/touch/:cid" do
      authenticate!
      box = Box.find(params[:id].to_i - 3000000000)
      card = Card.find(params[:cid].to_i - 1000000000)
      tag = card.tags.find_by box_id: box.id
      error!({ "error" => "405 Unknow Box ID" }, 405) unless box
      
      Box.increment_counter(:hit_count, box.id)
      #TODO: need lock? 
      tag.update(hit_count: tag.hit_count+1)
      
      present :boxInfo, box, with: APIEntities::Box
      present :totalCount, box.cards.count.to_s
      present :cards, box.cards.paginate(:page => params[:page], :per_page => 3), with: APIEntities::Card
    end
    
  end
  
  resources :cards do
    
    get "/favorites" do
      authenticate!
      current_user.
      Card.all.ids.map {|id| (id+1000000000).to_s }
    end
    
    post "/:id/collect" do
      { result: "1", message: "success" }
    end
    
    post "/create" do
      authenticate!
      #TODO create func
    end
    
    put "/:id/update" do
      authenticate!
      #TODO update func
    end
    
  end
  
  resources :idols do
    
    get "/:id" do
      
      authenticate!
      idol = Idol.find(params[:id].to_i - 4000000000)
      error!({ "error" => "409 Unknow Idol ID" }, 409) unless idol
      present :idolInfo, idol, with: APIEntities::Idol
      present :totalCount, idol.cards.count.to_s
      present :cards, idol.cards.paginate(:page => params[:page], :per_page => 3), with: APIEntities::Card
      
    end
    
    post "/:id/fan" do
      
      authenticate!
      idol = Idol.find(params[:id].to_i - 4000000000)
      error!({ "error" => "409 Unknow Idol ID" }, 409) unless idol
      current_user.idols << idol
      
    end
    
    get "/:id/hot" do
      
      authenticate!
      idol = Idol.find(params[:id].to_i - 4000000000)
      error!({ "error" => "409 Unknow Idol ID" }, 409) unless idol
      
    end
    
  end
  
end