class NotificationsController < ApplicationController
    def index
        end_user = EndUser.find(params[:id])

        # visitor_user = EndUser.find(params[:visitor_id])
        # visited_user = EndUser.find(params[:visited_id])

        notifications = end_user.passive_notifications.all.order("id DESC")

        # notifications.push(visitor_user)
        # notifications.push(visited_user)

        @notifications = notifications.to_json(include: [:visitor, :visited, :post_image, :post_comment])
        notifications.where(checked: false).each do |notification|
            notification.update(checked: true)
        end
        render :json => @notifications
    end
end