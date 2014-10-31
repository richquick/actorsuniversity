class QuestionResponse < ActiveRecord::Base
  belongs_to :question
  belongs_to :exam_sitting
  has_one :exam, through: :exam_sitting

  delegate :next_question, to: :exam_sitting

  validates :question_id, :uniqueness => {:scope => :exam_sitting_id,
                                          message: "Already answered" }

  has_many :guesses

  def possible_answers
    question.answers
  end

  def correct_answers
    possible_answers.map(&:correct).count true
  end

  has_many :correct_guesses, ->{ where correct: true },
    class_name: "Guess"

  accepts_nested_attributes_for :guesses

  validate :at_least_one_guess, on: :answered

  def at_least_one_guess
    unless guesses.count > 0
      errors[:guesses] << "Need to choose at least one answer"
    end
  end
end
