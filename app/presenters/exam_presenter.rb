class ExamPresenter < Draper::Decorator
  decorates Exam
  decorates_association :questions, with: QuestionPresenter
  delegate_all
end
