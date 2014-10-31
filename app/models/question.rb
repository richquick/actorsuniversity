class Question < ActiveRecord::Base
  belongs_to :exam
  has_many :answers
  accepts_nested_attributes_for :answers, allow_destroy: true
  validate :valid_answers
  has_many :question_responses

  def valid_answers
    if answers.length < 2
      errors[:answers] << "Need at least two answers"
    end

    unless answers.map(&:correct).include? true
      errors[:answers] << "Need at least one correct answer"
    end
  end
end
