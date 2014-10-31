class Guess < ActiveRecord::Base
  belongs_to :answer
  belongs_to :question_response, counter_cache: true

  delegate :text, to: :answer

  delegate :question, to: :question_response

  def correct_answers
    question.answers.where correct: true
  end
end
