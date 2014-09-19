# encoding: utf-8
require 'net/ftp'
require 'erb'
require 'open-uri'

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
          print_all_image(ftp, url+"/"+fname_es, key+"/"+fname)
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
      
      url = "/upload/"+params[:dir]
      
      print_all_image(ftp, url, url)
      ftp.close
      
      #present :msg, files
      
    end
    
  end
  
end