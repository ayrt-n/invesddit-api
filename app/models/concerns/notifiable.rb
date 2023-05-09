module Notifiable
  extend ActiveSupport::Concern

  included do
    def notify(notifiable:, account:)
      Notification.create(notifiable:, account:)
    end
  end
end
