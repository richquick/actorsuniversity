class ExamSitting < ActiveRecord::Base
  belongs_to :exam
  belongs_to :user
  has_many :question_responses
  has_many :questions, through: :exam

  delegate :title, to: :exam, prefix: true

  def answered_question_responses
    question_responses.where("guesses_count > 0")
  end

  def score
    question_responses.to_a.sum(&:score)
  end

  def guesses
    question_responses.map(&:guesses).flatten
  end

  def answers
    questions.map(&:answers).flatten
  end

  def max_score
    question_responses.to_a.sum(&:max_score)
  end

  def percentage
    return 0.0 if max_score == 0

    100.0 * score.to_f / max_score.to_f rescue 0.0
  end

  def answered_questions
    answered_question_responses.includes(:question).map(&:question)
  end

  def unanswered_questions
    questions - answered_questions
  end

  def first_unanswered_question
    unanswered_questions.first
  end

  def next_question
    first_unanswered_question
  end

  def all_answered?
    unanswered_questions.count == 0
  end
end
