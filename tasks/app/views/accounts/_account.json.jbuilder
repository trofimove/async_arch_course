json.extract! account, :id, :full_name, :public_id, :email, :role, :created_at, :updated_at
json.url account_url(account, format: :json)
