json.extract! message, :id, :title, :text, :username, :tel, :email, :company, :address, :created_at, :updated_at
json.url message_url(message, format: :json)
