json.id notification.id
json.message notification.message
json.read notification.read
json.details do
  json.partial! "api/v1/notifications/notifiable/#{notification.notifiable_type.downcase}",
                notifiable: notification.notifiable
end
json.created_at notification.created_at
