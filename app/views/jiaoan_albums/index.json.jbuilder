json.array!(@jiaoan_albums) do |jiaoan_album|
  json.extract! jiaoan_album, :id, :name, :creator, :cooperators, :logo
  json.url jiaoan_album_url(jiaoan_album, format: :json)
end
