class QuestionResponseDecorator < Draper::Decorator
  delegate_all

  def question_text
    question.question_text
  end

  def all_correct?
    correct_guesses.count == correct_answers
  end

  def question_result_css
    all_correct? ? 'correct' : 'incorrect'
  end

  def score
    @score ||=  
      begin
        guess_ids = guesses.map(&:answer_id)
        score, _ = QuestionScoreCalculator.calculate_score guess_ids, question.answers
        score
      end
  end

  delegate :max, :total, :incorrect, :correct, to: :score, prefix: true
  def results
    question.answers.map do |answer|
      guess = guesses.where(answer_id: answer.id).first

      guess_mark = guess.present? ? "✓" : ""
      answer_mark = answer.correct? ? "✓" : ""

      OpenStruct.new(
        css_class: css_class(guess, answer),
        answer_text: answer.text,
        guess_mark: guess_mark,
        answer_mark: answer_mark
      )
    end
  end

  private

  def css_class guess, answer
    if guess
      guess.correct? ? "correct" : "incorrect"
    else
      answer.correct? ? "not_guessed_but_correct_answer" : "not_guessed"
    end
  end
end
