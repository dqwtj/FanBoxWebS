# encoding: utf-8
require 'net/ftp'

class Admin < Grape::API
  
  version 'admin', :using => :path
  format :json
  
  helpers do
    
    def is_image_file?(fname)
      if fname.include?(".jpg") || fname.include?(".png") || fname.include?(".jpeg") || fname.include?(".gif")
        true
      else
        false
      end
    end
    
    def print_all_image(ftp, url)
      ftp.chdir(url)
      ftp.nlst.each do |file|
        fname = file.force_encoding("utf-8")
        if is_image_file?(fname)
          card = Card.new
          card.base_url = url+"/"+fname
          card.reset_from_base
          card.save
          #puts @counter.to_s + ":" + url+"/"+fname
          #@counter += 1
        else
          print_all_image(ftp, url+"/"+fname)
        end
      end
      ftp.chdir("..")
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
      
      url = "/upload/dev"
      
      print_all_image(ftp, url)
      
      #present :msg, files
      
    end
    
  end
  
end