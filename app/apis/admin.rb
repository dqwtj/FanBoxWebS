require 'net/ftp'

class Admin < Grape::API
  
  version 'admin', :using => :path
  format :json
  
  helpers do
    def load_idol(ftp, idol)
      
      ftp.nlst.each do |dir|
        puts dir.force_encoding("utf-8")
      end
      
    end
    
    def is_dir?(name)
      true
    end
    
  end
  
  namespace :shoot do
    
    post "/:dir" do
      
      @host = "v0.ftp.upyun.com"
      @user = "dqwtj/fanhe-photo"
      @password = "zqpm0120110705"
      @passive = true
      
      ftp = Net::FTP.new(@host, @user, @password)
      ftp.passive = @passive
      
      puts "logged in, start shooting..."
      
      ftp.chdir('/upload/'+params[:dir])
      
      ftp.nlst.each do |dir|
        load_idol(ftp, dir.force_encoding("utf-8")) if is_dir?(dir.force_encoding("utf-8"))
      end
      
      present :msg, "I feel good"
      
    end
    
  end
  
end