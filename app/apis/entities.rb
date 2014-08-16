module APIEntities
  class Box < Grape::Entity
  
    expose :id, :name
  
  end

  class Card < Grape::Entity
  
    expose :id, as: :cardId do |model, opts|
      (model.id + 1000000000).to_s
    end
    expose :title
    expose :height, as: :cardHeight
    expose :favorites_count, as: :favoritesCount
    expose :image_url, as: :imageUrl
    expose :preview_image_url, as: :previewImageUrl
    expose :userId do |model, opts|
      (model.user.id + 2000000000).to_s
    end
    expose :userInfo do |model, opts|
      model.user.info
    end
    expose :userAvatar do |model, opts|
      model.user.avatar_url
    end
    expose :boxes, using: APIEntities::Box
  end
end
