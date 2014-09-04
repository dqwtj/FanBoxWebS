require 'spec_helper'

describe API do
  include Rack::Test::Methods
  
  def app
    API
  end
  
  describe "POST /dev/users/sign_up" do
    it "returns an private token" do
      post "/dev/users/sign_up", :name => "测试用户1", :mobile => "1234567890", :password => "1234567"
      expect(last_response.status).to eq(201)
    end
  end
  
  describe "POST /dev/users/sign_in" do
    it "sign in with mobile, returns an private token" do
      user = create(:user)
      post "/dev/users/sign_in", :mobile => user.mobile, :password => user.encrypted_password
      expect(last_response.status).to eq(201)
    end
  end

end