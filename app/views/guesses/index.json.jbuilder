json.array!(@guesses) do |guess|
  json.extract! guess, :question_response_id, :answer_id, :correct
  json.url guess_url(guess, format: :json)
end
