json.array!(@users) do |user|
  json.extract! user, :id, :login, :password, :logo
  json.url user_url(user, format: :json)
end
