json.array!(@jiaoans) do |jiaoan|
  json.extract! jiaoan, :id, :name, :bh, :content, :author, :attachs, :medias
  json.url jiaoan_url(jiaoan, format: :json)
end
