# encoding: utf-8
require 'will_paginate'
require 'will_paginate/active_record'
require 'net/ftp'
require 'erb'
require 'open-uri'

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
    
    def is_image_file?(fname)
      if fname.include?(".jpg") || fname.include?(".png") || fname.include?(".jpeg") || fname.include?(".gif")
        true
      else
        false
      end
    end
    
    def print_all_image(ftp, url, key)
      ftp.chdir(key)
      ftp.nlst.each do |file|
        fname = file.force_encoding("utf-8")
        fname_es = ERB::Util.url_encode(fname)
        if is_image_file?(fname_es.downcase)  
          # Card find & init
          card = Card.find_or_initialize_by(key_url: key+"/"+fname)
          # Reset from base url
          card.base_url = url+"/"+fname_es
          card.user_id = @user.id if @user
          card.reset_from_key
          # Reset from image info
          begin
            open(card.img_info_url) do |http|            
              html_response = http.read
              json = JSON.parse(html_response)
              card.image_width = json["width"]
              card.image_height = json["height"]
              card.image_type = json["type"]
            end
          rescue StandardError,Timeout::Error, SystemCallError, Errno::ECONNREFUSED
            puts  $!
          else
            puts "opening "+card.img_info_url
            puts "with key "+card.key_url
          end
          card.save
        else
          puts "digging into "+ key+"/"+fname
          print_all_image(ftp, url+"/"+fname_es, key+"/"+fname) unless fname.include?(".")
        end
      end
      ftp.chdir("..")
    end
    
  end
  
  resources :users do
    
    post "/sign_up" do
      # signature = Digest::MD5.hexdigest(params[:mobile] + '&'+'vuEqnXFYyJnGiiJeI7lbwpmHI0M')
      # error!({ "error" => "401 Unauthorized" }, 401) unless signature = params[:signature]
      error!({ "error" => "404 Creatation Failed", "messange" =>  "User Name Used" }, 404) if Box.find_by name: params[:name]
      error!({ "error" => "404 Creatation Failed", "messange" =>  "Mobile Number Used" }, 404) if params[:mobile]!="weibo" && User.find_by(mobile: params[:mobile]) 
      error!({ "error" => "404 Creatation Failed", "messange" =>  "User Name Used" }, 404) if User.find_by name: params[:name]
      user = User.new do |u|
        u.name = params[:name]
        u.mobile = params[:mobile]
        u.encrypted_password = params[:password]
        u.weibo_uid = params[:uid]
        u.info = params[:info]
        u.avatar_url = params[:avatar_url]
        u.address = params[:address]
        u.gender = params[:gender]
      end
      if user.save
        present :token, user.private_token
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
    
    get "/favorites" do
      authenticate!
      present :totalCount, current_user.favorites.count.to_s
      present :cards, current_user.favorites.paginate(:page => params[:page], :per_page => 10), with: APIEntities::Card
    end
    
    get "/:id" do
      authenticate!
      user = User.find(params[:id].to_i - 2000000000)
      error!({ "error" => "408 Unknow User ID" }, 408) unless user
      present :userInfo, user, with: APIEntities::User
      present :totalCount, user.cards.count.to_s
      present :cards, user.cards.includes(:marks, :tags, :user).paginate(:page => params[:page], :per_page => 10), with: APIEntities::Card
    end
    
    post "/:id/follow" do
      authenticate!
      user = User.find(params[:id].to_i - 2000000000)
      error!({ "error" => "408 Unknow User ID" }, 408) unless user
      user.followers << current_user
      { result: "1", message: "success" }
    end
    
    post "/:id/unfollow" do
      authenticate!
      user = User.find(params[:id].to_i - 2000000000)
      error!({ "error" => "408 Unknow User ID" }, 408) unless user
      current_user.followees.delete(user)
      { result: "1", message: "success" }
    end
    
  end
  
  namespace :stream do
    
    get do   
      present :totalCount, Card.all.count.to_s
      present :data, Card.order(created_at: :desc).includes(:marks, :tags, :user).paginate(:page => params[:page], :per_page => 10), with: APIEntities::Card
    end
    
    get "/home" do
      authenticate!
      b_ids = current_user.boxes.ids
      cards = Card.joins(:tags).where(tags: {box_id: b_ids}).includes(:user, :tags, :marks).paginate(:page => params[:page], :per_page => 10)
      present :totalCount, cards.count.to_s
      present :data, cards, with: APIEntities::Card
    end
    
  end
  
  resources :boxes do
    
    get "/hot" do
      authenticate!
      boxes = Box.where(:box_type => "tag")
      present :totalCount, boxes.count.to_s
      present :boxes, boxes.order(hit_count: :desc).paginate(:page => params[:page], :per_page => 20), with: APIEntities::Box
    end
    
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
      present :totalCount, box.tags_count.to_s
      present :cards, box.cards.includes(:marks, :tags, :user).paginate(:page => params[:page], :per_page => 10), with: APIEntities::Card
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
      present :cards, box.cards.includes(:marks, :tags, :user).paginate(:page => params[:page], :per_page => 10), with: APIEntities::Card
    end
    
  end
  
  resources :cards do
    
    post  do
      authenticate!
      card = Card.new
      card.title = params[:title] if params[:title]
      card.height = params[:height] if params[:height]
      card.base_url = params[:base_url] if params[:base_url]
      if card.save
        current_user.cards << card
        { result: "1", message: card.card_id }
      else
        error!({ "error" => "410 Creation Failed", "message" => card.errors }, 410)
      end
    end
    
    put "/:id" do
      authenticate!
      card = current_user.cards.find(params[:id].to_i - 1000000000)
      error!({ "error" => "409 Unknow Card ID" }, 409) unless card
      card.title = params[:title] if params[:title]
      card.height = params[:height] if params[:height]
      card.base_url = params[:base_url] if params[:info]
      if card.save
        { result: "1", message: "success" }
      else
        error!({ "error" => "404 Creation Failed", "message" => card.errors }, 404)
      end
    end
    
    post "/:id/zan" do
      authenticate!
      card = Card.find(params[:id].to_i - 1000000000)
      error!({ "error" => "409 Unknow Card ID" }, 409) unless card
      if !current_user.zans.exists?(card)
        current_user.zans << card
        Card.increment_counter(:zans_count, card.id)
      end
      { result: "1", message: "success" }
    end
    
    post "/:id/unzan" do
      authenticate!
      card = Card.find(params[:id].to_i - 1000000000)
      error!({ "error" => "409 Unknow Card ID" }, 409) unless card
      if current_user.zans.exists?(card)
        current_user.zans.delete(card) if card
        Card.decrement_counter(:zans_count, card.id)
      end
      { result: "1", message: "success" }
    end
    
    post "/:id/tag" do
      authenticate!
      card = Card.find(params[:id].to_i - 1000000000)
      error!({ "error" => "409 Unknow Card ID" }, 409) unless card
      params[:box_ids].each do |id|
        bid = id.to_i - 3000000000
        if !card.boxes.ids.include?(bid) 
          box = Box.find(bid)
          card.boxes << box if box
        end
      end
      { result: "1", message: "success" }
    end
    
    post "/:id/mark" do
      authenticate!
      card = Card.find(params[:id].to_i - 1000000000)
      error!({ "error" => "409 Unknow Card ID" }, 409) unless card
      params[:idol_ids].each do |id|
        iid = id.to_i - 4000000000
        if !card.idols.ids.include?(iid) 
          idol = Idol.find(iid)
          card.idols << idol if idol
        end
      end
      { result: "1", message: "success" }
    end
    
    post "/:id/report" do
      authenticate!
      card = Card.find(params[:id].to_i - 1000000000)
      error!({ "error" => "409 Unknow Card ID" }, 409) unless card
      { result: "1", message: "success" }
    end
    
    post "/:id/favorite" do
      authenticate!
      card = Card.find(params[:id].to_i - 1000000000)
      error!({ "error" => "409 Unknow Card ID" }, 409) unless card
      current_user.add_favorite(card.card_id)
      #TODO: Unsafe increment
      Card.increment_counter(:favorites_count, card.id)
      { result: "1", message: "success" }
    end
    
    post "/:id/unfavorite" do
      authenticate!
      card = Card.find(params[:id].to_i - 1000000000)
      error!({ "error" => "409 Unknow Card ID" }, 409) unless card
      current_user.del_favorite(card.card_id)
      #TODO: Unsafe decrement
      Card.decrement_counter(:favorites_count, card.id)
      { result: "1", message: "success" }
    end
    
    delete "/:id" do
      authenticate!
      card = current_user.cards.find(params[:id].to_i - 1000000000)
      error!({ "error" => "409 Unknow Card ID" }, 409) unless card
      card.destroy
      { result: "1", message: "success" }
    end
    
  end
  
  resources :idols do
    
    get do
      
      authenticate!
      present :totalCount, Idol.all.count.to_s
      present :idols, Idol.all.paginate(:page => params[:page], :per_page => 10), with: APIEntities::Idol
      
    end
    
    get "/:id" do
      
      authenticate!
      idol = Idol.find(params[:id].to_i - 4000000000)
      error!({ "error" => "409 Unknow Idol ID" }, 409) unless idol
      present :idolInfo, idol, with: APIEntities::Idol
      present :totalCount, idol.cards.count.to_s
      present :cards, idol.cards.includes(:marks, :tags, :user).paginate(:page => params[:page], :per_page => 10), with: APIEntities::Card
      
    end
    
    post "/:id/fan" do
      
      authenticate!
      idol = Idol.find(params[:id].to_i - 4000000000)
      error!({ "error" => "409 Unknow Idol ID" }, 409) unless idol
      current_user.idols << idol
      { result: "1", message: "success" }
    end
    
    get "/:id/hot_boxes" do
      
      authenticate!
      idol = Idol.find(params[:id].to_i - 4000000000)
      error!({ "error" => "409 Unknow Idol ID" }, 409) unless idol
      present :totalCount, idol.boxes.count.to_s
      present :boxes, idol.boxes.order(hit_count: :desc).paginate(:page => params[:page], :per_page => 10), with: APIEntities::Box
      
    end
        
  end
  
  namespace :shoot do
    
    post "/:dir" do
      
      @host = "v0.ftp.upyun.com"
      @user = "dqwtj/fanhe-photo"
      @password = "zqpm0120110705"
      @passive = true
      @counter = 0
      
      ftp = Net::FTP.new(@host, @user, @password)
      ftp.passive = @passive
      
      puts "logged in, start shooting..."
      
      url = "/upload/"+params[:dir]
      @user = User.find params[:uid] if params[:uid]
      
      print_all_image(ftp, url, url)
      ftp.close
            
    end
    
  end
  
end