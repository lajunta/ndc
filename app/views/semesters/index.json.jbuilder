json.array!(@semesters) do |semester|
  json.extract! semester, :id, :full_name, :short_name, :started_at, :ended_at
  json.url semester_url(semester, format: :json)
end
