module APIEntities
  class Tag < Grape::Entity
  
    expose :box_id, as: :boxId do |model, opts|
      (model.box_id + 3000000000).to_s
    end
    expose :name
    expose :tag_type, as: :tagType
    expose :hit_count, as: :hitCount, if: lambda { |model, opts| model.tag_type == "tag" }
  
  end

  class Card < Grape::Entity
  
    expose :card_id, as: :cardId
    expose :title
    expose :height, as: :cardHeight
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
  end
  
  class Box < Grape::Entity
    expose :id, as: :boxId do |model, opts|
      (model.id + 3000000000).to_s
    end
    expose :name
    expose :subscribes_count
  end
  
  class Profile < Grape::Entity
    expose :user_id, as: :userId
    expose :avartar_url, as: :avartarUrl
    expose :favoritesIds do |model, opts|
      model.favorites.ids.map {|id| (id+1000000000).to_s }
    end
  end
  
end
