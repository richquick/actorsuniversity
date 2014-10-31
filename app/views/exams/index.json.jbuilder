json.array!(@exams) do |exam|
  json.extract! exam, :title, :description
  json.url exam_url(exam, format: :json)
end
