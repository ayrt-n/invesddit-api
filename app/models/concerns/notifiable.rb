module Notifiable
  extend ActiveSupport::Concern

  included do
    def notify(notifiable:, account:, message:)
      Notification.create(notifiable:, account:, message:)
    end
  end
end
