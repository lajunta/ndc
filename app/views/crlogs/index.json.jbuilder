json.array!(@crlogs) do |crlog|
  json.extract! crlog, :id, :croom, :banji, :use_date, :course_name, :jiece, :computer_status, :garbage_status, :place_status, :status, :logger, :closed_by, :desc
  json.url crlog_url(crlog, format: :json)
end
