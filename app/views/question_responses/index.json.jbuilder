json.array!(@question_responses) do |question_response|
  json.extract! question_response, :answer
  json.url question_response_url(question_response, format: :json)
end
