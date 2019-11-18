class NotificationsController < ApplicationController
    def index
        end_user = EndUser.find(params[:id])
        notifications = end_user.passive_notifications.all.order("id DESC")
        @notifications = notifications.to_json(include: [:visitor, :visited, :post_image, :post_comment])
        notifications.where(checked: false).each do |notification|
            notification.update(checked: true)
        end
        render :json => @notifications
    end
end