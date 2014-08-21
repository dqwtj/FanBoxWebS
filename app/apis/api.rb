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
      signature = Digest::MD5.hexdigest(params[:mobile] + '&'+'vuEqnXFYyJnGiiJeI7lbwpmHI0M')
      # error!({ "error" => "401 Unauthorized" }, 401) unless signature = params[:signature]
      user = User.new do |u|
        u.name = params[:name]
        u.mobile = params[:mobile]
        u.encrypted_password = params[:password]
      end
      if user.save
        present :token, user.update_private_token
      else
        error!({ "error" => "404 Creatation Failed", "message" => user.errors }, 404)
      end
    end
    
    post "/sign_in" do
      user = User.find_by mobile: params['mobile']
      error!({ "error" => "402 Unknow Mobile User" }, 402) unless user
      error!({ "error" => "403 Wrong Password" }, 403) unless user.encrypted_password == params[:password]
      present :token, user.update_private_token
    end
    

  end
  
  namespace :stream do
    
    get do
      present :totalCount, Card.all.count.to_s
      present :data, Card.all, with: APIEntities::Card
    end
    
  end
  
  resources :cards do
    
    get "/favorites" do
      Card.all.ids.map {|id| (id+1000000000).to_s }
    end
    
    post "/:id/collect" do
      { result: "1", message: "success" }
    end
    
  end
  
end