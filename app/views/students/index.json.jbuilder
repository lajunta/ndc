json.array!(@students) do |student|
  json.extract! student, :id, :realname, :sex, :birthday, :default_group, :other_groups, :address, :hometel, :mobile, :father_name, :mother_name, :father_workplace, :mother_workplace, :father_profession, :mother_profession, :father_tel, :mother_tel, :intro, :logo
  json.url student_url(student, format: :json)
end
