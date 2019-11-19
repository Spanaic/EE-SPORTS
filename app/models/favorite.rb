class Favorite < ApplicationRecord
    belongs_to :end_user
    belongs_to :post_image, counter_cache: :favorites_count

    validates :end_user_id, :uniqueness => {:scope => :post_image_id}

end
