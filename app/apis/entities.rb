module APIEntities
  class Tag < Grape::Entity
  
    expose :box_id, as: :boxId do |model, opts|
      (model.id + 3000000000).to_s
    end
    expose :name, :hit_count
  
  end

  class Card < Grape::Entity
  
    expose :id, as: :cardId do |model, opts|
      (model.id + 1000000000).to_s
    end
    expose :title
    expose :height, as: :cardHeight
    expose :favorites_count, as: :favoritesCount
    expose :img_standard_url, as: :imageUrl
    expose :img_preview_url, as: :previewImageUrl
    expose :userId do |model, opts|
      (model.user.id + 2000000000).to_s
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
    expose :cards, using: APIEntities::Card
  end
  
end
