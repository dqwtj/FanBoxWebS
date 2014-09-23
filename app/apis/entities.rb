module APIEntities
  class Tag < Grape::Entity
  
    expose :box_id, as: :boxId do |model, opts|
      (model.box_id + 3000000000).to_s
    end
    expose :name
    expose :tag_type, as: :tagType
    expose :hit_count, as: :hitCount, if: lambda { |model, opts| model.tag_type == "tag" }
  
  end
  
  class Idol < Grape::Entity
    expose :idol_id, as: :idolId
    expose :name
    expose :avatar_url, as: :avatarUrl
  end

  class Card < Grape::Entity
  
    expose :card_id, as: :cardId
    expose :title
    expose :cardHeight do |model, opts|
      if model.image_width
        (model.image_height.to_i * 640 / model.image_width.to_i).to_i
      else
        0
      end
      
    end
    expose :favorites_count, as: :favoritesCount
    expose :img_standard_url, as: :imageUrl
    expose :img_preview_url, as: :previewImageUrl
    #TODO need less SQL query
    expose :userId do |model, opts|
      model.user.user_id
    end
    expose :userInfo do |model, opts|
      model.user.info
    end
    expose :userAvatar do |model, opts|
      model.user.avatar_url
    end
    expose :tags, using: APIEntities::Tag
    expose :idols, using: APIEntities::Idol
  end
  
  class Box < Grape::Entity
    expose :id, as: :boxId do |model, opts|
      (model.id + 3000000000).to_s
    end
    expose :name
    expose :hit_count, as: :hitCount
  end
  
  class Profile < Grape::Entity
    expose :user_id, as: :userId
    expose :avatar_url, as: :avatarUrl
    expose :info, :address, :gender
    expose :cardsIds do |model, opts|
      model.cards.ids.map {|id| (id+1000000000).to_s }
    end
    expose :favoritesIds do |model, opts|
      model.favorites.ids.map {|id| (id+1000000000).to_s }
    end
    expose :boxes, using: APIEntities::Box
  end
  
  class User < Grape::Entity
    expose :user_id, as: :userId
    expose :name, :gender, :address, :info
    expose :avatar_url, as: :avatarUrl
    expose :idols, using: APIEntities::Idol
  end
  
end
