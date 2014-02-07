json.array!(@submissions) do |submission|
  json.extract! submission, :id, :submitter, :archives, :hub_id
  json.url submission_url(submission, format: :json)
end
