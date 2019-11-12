class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :omniauthable

        validates :name, presence: true, length: {minimum: 1, maximum: 20}
        validates :profile_name, presence: true, format: { with: /\A[a-zA-Z\d]+\z/ }, length: {minimum: 1, maximum: 100}

  has_and_belongs_to_many :post_comments, dependent: :destroy

  has_many :post_images, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id, dependent: :destroy
  has_many :followings, through: :active_relationships, source: :follower
  has_many :passive_relationships, class_name: "Relationship", foreign_key:  :follower_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :following

  has_many :active_notifications, class_name: "Notification", foreign_key: :visitor_id, dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: :visited_id, dependent: :destroy

  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end

  attachment :profile_image

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
    unless user
      user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        name:     auth.info.name,
        profile_name:  auth.uid,
        email:    auth.info.email,
        password: Devise.friendly_token[0,20]
      )
    end
    user
  end

  def create_notification_follow(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow',)

      notification.save if notification.valid?
    end
  end
end
