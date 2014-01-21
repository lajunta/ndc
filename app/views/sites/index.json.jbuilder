json.array!(@sites) do |site|
  json.extract! site, :id, :name, :uploader, :path, :original_path, :type
  json.url site_url(site, format: :json)
end
