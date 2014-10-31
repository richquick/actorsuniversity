class ExamSittingDecorator < Draper::Decorator
  delegate_all
  decorates_association :question_responses

  delegate :title, :description, to: :exam

  def number_of_questions
    exam.questions.count
  end

  def score_percentage
    "#{percentage.round 1}%"
  end

  def progress
    100.0 * question_responses.count.to_f / number_of_questions.to_f
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
