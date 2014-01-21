json.array!(@apps) do |app|
  json.extract! app, :id, :name, :code, :callback, :url, :owner, :email
  json.url app_url(app, format: :json)
end
