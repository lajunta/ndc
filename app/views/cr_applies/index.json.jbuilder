json.array!(@cr_applies) do |cr_apply|
  json.extract! cr_apply, :id, :applyer, :semester, :croom, :course, :wday, :jiece
  json.url cr_apply_url(cr_apply, format: :json)
end
