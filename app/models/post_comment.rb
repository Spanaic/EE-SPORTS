class PostComment < ApplicationRecord
    belongs_to :end_user, optional: true
    belongs_to :post_image, optional: true
    validates :comment, presence: true, length: {maximum: 99}

    has_many :notifications, dependent: :destroy
end
