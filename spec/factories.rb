# encoding: utf-8
FactoryGirl.define do

  factory :user do
    sequence(:email)         { |n| "email#{n}@example.com" }
    sequence(:name)          { |n| "测试用户#{n}" }
    sequence(:info)          { |n| "我是测试用户#{n}号" }
    sequence(:mobile)        { |n| "1346659338#{n}" }
    sequence(:address)       { |n| "知春路#{n}号院" }
    gender "男"
    avatar_url "http://tp2.sinaimg.cn/1047641505/180/5649838344/1"
    encrypted_password "1234567890"
    
    factory :user_with_cards do
      # cards_count is declared as an ignored attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      ignore do
        cards_count 5
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including ignored
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |user, evaluator|
        create_list(:card, evaluator.cards_count, user: user)
      end
    end
    
  end
  
  factory :card do
    sequence(:title)          { |n| "我是无敌的小卡片#{n}号" }
    sequence(:height)         { |n| "23#{n}" }
    sequence(:base_url)       { |n| "/test/card_#{n}.jpg" }
    favorites_count           { |n| "10#{n}" }
    user
  end
  
  factory :subscribe do
    user factory: :user
    box
  end
  
  factory :tag do
    card factory: :card
    box
  end
  
  factory :box do
    sequence(:name)           { |n| "小盒子#{n}号"}
    info  "我是测试用的无敌小盒子"
    
    factory :box_with_subscribers do
      ignore do
        users_count 5
      end

      after(:create) do |box, evaluator|
        create_list(:subscribe, evaluator.users_count, box: box)
      end
    end
    
    factory :box_with_cards do
      ignore do
        cards_count 5
      end

      after(:create) do |box, evaluator|
        create_list(:tag, evaluator.cards_count, box: box)
      end
    end
    
  end
  
end
