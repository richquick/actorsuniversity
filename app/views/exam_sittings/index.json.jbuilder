json.array!(@exam_sittings) do |exam_sitting|
  json.extract! exam_sitting, :exam_id, :user_id, :score, :max_score, :completed
  json.url exam_sitting_url(exam_sitting, format: :json)
end
