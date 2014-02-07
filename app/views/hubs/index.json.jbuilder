json.array!(@hubs) do |hub|
  json.extract! hub, :id, :name, :creator, :users, :groups
  json.url hub_url(hub, format: :json)
end
