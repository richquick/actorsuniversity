class QuestionPresenter < Draper::Decorator
  decorates_association :answers, with: AnswerPresenter
  delegate :question_text
end
