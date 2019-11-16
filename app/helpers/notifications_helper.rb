module NotificationsHelper
    def unchecked_notifications
        @notifications = end_user.passive_notifications.where(checked: false)
    end
end
# module NotificationsHelper
#     def unchecked_notifications
#         @notifications = current_user.passive_notifications.where(checked: false)
#     end
# end
