class Favorite < ApplicationRecord
    belongs_to :end_user
    belongs_to :post_image, counter_cache: :favorites_count
end
