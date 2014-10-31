class AnswerPresenter < Draper::Decorator
  delegate :correct, :text

  def css_class
    correct ? 'correct' : 'incorrect'
  end
end
