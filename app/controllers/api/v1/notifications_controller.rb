module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authenticate
      before_action :sanitize_pagination_params, only: :index

      # GET /notifications
      def index
        @notifications = @current_account.notifications
                                         .sort_by_new
                                         .page(params[:page], params[:limit])
                                         .includes(notifiable: [{
                                                     post: [:community]
                                                   }, {
                                                     account: [avatar_attachment: :blob]
                                                   }])
      end

      # PATCH /notifications/:id
      # Currently only used to mark notification as read/unread
      def update
        @notification = Notification.find(params[:id])
        return access_denied unless @notification.account == @current_account

        if @notification.update(notification_params)
          head :no_content
        else
          unprocessable_entity(@notification)
        end
      end

      # PATCH /notifications
      # Marks all notifications as read
      def read_all
        if @current_account.mark_all_notifications_read
          head :no_content
        else
          unprocessable_entity(@notifications)
        end
      end

      private

      # Allowlist for notification params
      def notification_params
        params.require(:notification).permit(:read)
      end
    end
  end
end
