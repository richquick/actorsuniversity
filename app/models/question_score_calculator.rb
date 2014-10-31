class QuestionScoreCalculator
  Score = Struct.new(:max, :correct, :incorrect, :total)

  attr_reader :guess_ids, :answers

  def self.calculate_score guess_ids, answers
    new(guess_ids, answers).calculate_score
  end

  def initialize guess_ids, answers
    @guess_ids, @answers = guess_ids.map(&:to_i), answers
  end

  def calculate_score
    score = Score.new max, num_correct_guesses, num_incorrect_guesses, total

    [score, {:correct => correct_guesses, incorrect: incorrect_guesses}]
  end

  private

  def max
    answers.map(&:correct).count true
  end

  def total
    [0, num_correct_guesses - num_incorrect_guesses].max
  end

  def num_correct_guesses
    correct_guesses.length
  end

  def num_incorrect_guesses
    incorrect_guesses.length
  end

  def correct_guesses
    @correct_guesses ||= correct_ids(:select) & guess_ids
  end

  def incorrect_guesses
    @incorrect_guesses ||= correct_ids(:reject) & guess_ids
  end

  def correct_ids meth
    answers.send(meth, &:correct).map(&:id)
  end
end
