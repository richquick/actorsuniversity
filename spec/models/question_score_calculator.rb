require 'fast_spec_helper'

describe QuestionScoreCalculator do
  let(:evens_are_correct) { [
    double('incorrect answer', id: 1, correct: false),
    double('correct answer',   id: 2, correct: true),
    double('incorrect answer', id: 3, correct: false),
    double('correct answer',   id: 4, correct: true),
    double('incorrect answer', id: 5, correct: false),
    double('correct answer',   id: 6, correct: true),
    double('incorrect answer', id: 7, correct: false),
    double('correct answer',   id: 8, correct: true),
    double('incorrect answer', id: 9, correct: false),
    double('correct answer',   id: 10, correct: true),
    double('incorrect answer', id: 11, correct: false),
  ] }


  let(:guesses) { response.last }
  let(:score) { response.first }
  let(:response) { QuestionScoreCalculator.calculate_score(guess_ids, evens_are_correct) }

  context do
    let(:guess_ids) { [1, 2, 3, 5, 6] }
    specify do
      score.correct.should == 2
      score.incorrect.should == 3
      score.total.should == 0
    end
  end

  context do
    let(:guess_ids) { [1, 3, 5, 7] }
    specify do
      score.correct.should == 0
      score.incorrect.should == 4
      score.total.should == 0
    end
  end

  context do
    let(:guess_ids) { [2, 4, 6, 8] }
    specify do
      score.correct.should == 4
      score.incorrect.should == 0
      score.total.should == 4
    end
  end

  context do
    let(:guess_ids) { [1, 4, 6, 8] }
    specify do
      score.correct.should == 3
      score.incorrect.should == 1
      score.total.should == 2
    end
  end
end


