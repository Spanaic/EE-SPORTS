class Hashtag < ApplicationRecord
    has_and_belongs_to_many :post_images
    validates :hashname, presence: true, length: {maximum: 99}
end
