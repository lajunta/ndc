json.array!(@api_keys) do |api_key|
  json.extract! api_key, :id, :app_id, :request_token, :access_token, :user_id, :scopes, :expires_at
  json.url api_key_url(api_key, format: :json)
end
