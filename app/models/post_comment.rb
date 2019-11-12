class PostComment < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :post_image, optional: true
    validates :comment, presence: true, length: {maximum: 99}

    has_and_belongs_to_many :users, dependent: :destroy
    has_many :notifications, dependent: :destroy
end
