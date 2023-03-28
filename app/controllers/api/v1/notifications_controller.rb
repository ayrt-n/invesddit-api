module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authenticate
      before_action :sanitize_pagination_params, only: :index

      def index
        @notifications = @current_account.notifications
                                         .by_newest
                                         .page(params[:page], params[:limit])
                                         .includes(notifiable: [{
                                                     post: [:community]
                                                   }, {
                                                     account: [avatar_attachment: :blob]
                                                   }])
      end

      def update
        @notification = Notification.find(params[:id])
        return access_denied unless @notification.account == @current_account

        if @notification.update(notification_params)
          head :no_content
        else
          unprocessable_entity(@notification)
        end
      end

      def read_all
        if @current_account.mark_all_notifications_read
          head :no_content
        else
          unprocessable_entity(@notifications)
        end
      end

      private

      def notification_params
        params.require(:notification).permit(:read)
      end
    end
  end
end
