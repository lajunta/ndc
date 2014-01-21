json.array!(@courses) do |course|
  json.extract! course, :id, :name, :code, :intro
  json.url course_url(course, format: :json)
end
