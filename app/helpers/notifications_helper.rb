module NotificationsHelper
    def unchecked_notifications
        @notifications = end_user.passive_notifications.where(checked: false)
    end
end
