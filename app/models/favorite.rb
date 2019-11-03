class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :post_image, counter_cache: :favorites_count
end
