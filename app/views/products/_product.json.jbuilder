json.extract! product, :id, :name, :profile, :created_at, :updated_at
json.url product_url(product, format: :json)
