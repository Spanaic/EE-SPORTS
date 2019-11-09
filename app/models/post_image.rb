class PostImage < ApplicationRecord
    has_many :post_comments, dependent:  :destroy
    has_many :favorites, dependent:  :destroy
    belongs_to :user
    has_and_belongs_to_many :hashtags
    has_many :notifications, dependent: :destroy

    # attachment :post_image

    # validates :post_image, presence: true
    # validates :caption, presence: true, length: {maximum: 140}

    def favorited_by?(current_user)
        favorites.where(user_id: current_user.id).exists?
    end

    after_create do
        post_image = PostImage.find_by(id: self.id)
        hashtags = self.caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
        hashtags.uniq.map do |hashtag|
            tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
            post_image.hashtags << tag
        end
    end
    before_update do
        post_image = PostImage.find_by(id: self.id)
        post_image.hashtags.clear
        hashtags = self.caption.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
        hashtags.uniq.map do |hashtag|
            tag = Hashtag.find_or_create_by(hashname: hashtag.downcase.delete('#'))
            post_image.hashtags << tag
        end
    end

    def create_notification_favorite(current_user)
        temp = Notification.where(["visitor_id = ? and visited_id = ? and post_image_id = ? and action = ?", current_user.id, user_id, id, 'favorite'])
        if temp.blank?
            notification = current_user.active_notifications.new(visited_id: user_id, post_image_id: id, action: 'favorite')
            if notification.visitor_id == notification.visited.id
                notification.checked = true
            end
            notification.save if notification.valid?
        end
    end

    def create_notification_post_comment(current_user, post_comment_id)
        temp_ids = PostComment.select(:user_id).where(post_image_id: id).where.not(user_id: current_user.id).distinct
        temp_ids.each do |temp_id|
            save_notification_post_comment(current_user, @new_post_comment, temp_id['user_id'])
        end
        save_notification_post_comment(current_user, @new_post_comment, user_id) if temp_ids.blank?
    end

    def save_notification_post_comment(current_user, comment_id, visited_id)

        notification = current_user.active_notifications.new(
            visited_id: user_id,
            post_image_id: id,
            post_comment_id: comment_id,
            action: 'comment',
        )
        if notification.visitor_id == notification.visited_id
            notification.checked = true
        end
        notification.save if notification.valid?
    end
end