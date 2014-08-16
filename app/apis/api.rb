class API < Grape::API
  
  version 'dev', :using => :path
  format :json
  
  resource 'posts' do
    get "/" do
      Post.all
    end
    
    get "/:id" do 
      Post.find_by_sql "SELECT SLEEP(#{ENV['WAIT_TIME'].to_f})"
      Post.find(params['id'])
    end
    
    post "/create" do
      Post.create(params['post'])
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