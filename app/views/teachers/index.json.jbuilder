json.array!(@teachers) do |teacher|
  json.extract! teacher, :id, :realname, :sex, :birthday, :tel, :mobile, :email, :default_group, :logo
  json.url teacher_url(teacher, format: :json)
end
