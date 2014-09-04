# encoding: utf-8
FactoryGirl.define do
  sequence(:email)         { |n| "email#{n}@example.com" }
  sequence(:name)          { |n| "测试用户#{n}" }
  sequence(:info)          { |n| "我是测试用户#{n}号" }
  sequence(:mobile)        { |n| "1346659338#{n}" }

  factory :user do
    name
    mobile
    info
    email
    avatar_url "http://tp2.sinaimg.cn/1047641505/180/5649838344/1"
    encrypted_password "1234567890"
  end

  
end
