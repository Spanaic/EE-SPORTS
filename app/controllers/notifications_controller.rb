class NotificationsController < ApplicationController
    protect_from_forgery :except => [:update]

    def index
        end_user = EndUser.find(params[:id])
        notifications = end_user.passive_notifications.all.order("id DESC")
        @notifications = notifications.to_json(include: [:visitor, :visited, :post_image, :post_comment])

        render :json => @notifications
    end

    def update

        notification = Notification.find(params[:id])

        if notification.update(checked: true)
            end_user = EndUser.find(params[:end_user_id])
            notifications = end_user.passive_notifications.all.order("id DESC")
            notifications_list = notifications.to_json(include: [:visitor, :visited, :post_image, :post_comment])
            render :json => notifications_list
        end
    end
end