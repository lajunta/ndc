json.array!(@groups) do |group|
  json.extract! group, :id, :name, :type
  json.url group_url(group, format: :json)
end
