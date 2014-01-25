json.array!(@cr_schedules) do |cr_schedule|
  json.extract! cr_schedule, :id, :semester, :croom, :content, :used
  json.url cr_schedule_url(cr_schedule, format: :json)
end
