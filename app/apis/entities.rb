module APIEntities
  class Tag < Grape::Entity
  
    expose :boxId do |model, opts|
      (model.box_id + 3000000000).to_s
    end
    expose :name
    expose :tag_type, as: :tagType
    expose :hit_count, as: :hitCount, if: lambda { |model, opts| model.tag_type == "tag" }
  
  end
  
  class Mark < Grape::Entity
    expose :idolId  do |model, opts|
      (model.idol_id + 4000000000).to_s
    end
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
        if model.height
          model.height
        else
          0
        end
      end
      
    end
    expose :zans_count, as: :zansCount
    expose :img_standard_url, as: :imageUrl
    expose :img_preview_url, as: :previewImageUrl
    #TODO need less SQL query
    expose :userId do |model, opts|
      model.user.user_id
    end
    expose :userName do |model, opts|
      model.user.name
    end
    expose :userAvatar do |model, opts|
      model.user.avatar_url
    end
    expose :tags, using: APIEntities::Tag
    expose :marks, using: APIEntities::Mark
  end
  
  class Box < Grape::Entity
    expose :box_id, as: :boxId
    expose :name
    expose :hit_count, as: :hitCount
    expose :box_type, as: :boxType
  end
  
  class Idol < Grape::Entity
    expose :idol_id, as: :idolId
    expose :name
    expose :avatar_url, as: :avatarUrl
  end
  
  class Profile < Grape::Entity
    expose :user_id, as: :userId
    expose :name
    expose :avatar_url, as: :avatarUrl
    expose :info, :address, :gender, :weibo_uid
    expose :cardsIds do |model, opts|
      model.cards.ids.map {|id| (id+1000000000).to_s }
    end
    expose :zansIds do |model, opts|
      model.zans.ids.map {|id| (id+1000000000).to_s }
    end
    expose :followeesIds do |model, opts|
      model.followees.ids.map {|id| (id+2000000000).to_s }
    end
    expose :favorites_list, as: :favoritesIds
    expose :boxes, using: APIEntities::Box
    expose :idols, using: APIEntities::Idol
  end
  
  class User < Grape::Entity
    expose :user_id, as: :userId
    expose :name, :gender, :address, :info
    expose :avatar_url, as: :avatarUrl
    expose :idols, using: APIEntities::Idol
  end
  
  class Nine < Grape::Entity
    expose :box_id, as: :boxId
    expose :name
    expose :avatar_url, as: :avatarUrl
    expose :line_1
    expose :line_2
    expose :hit_count, as: :hitCount
  end
  
end
