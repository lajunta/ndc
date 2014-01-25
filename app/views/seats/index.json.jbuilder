json.array!(@seats) do |seat|
  json.extract! seat, :id, :semester, :tname, :banji, :croom, :course_name, :arrangement
  json.url seat_url(seat, format: :json)
end
