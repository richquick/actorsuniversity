require 'spec_helper'

describe Dao::ExamSitting do
  let(:exam_sitting) { Fabricate :exam_sitting }
  let(:dao) { Dao::ExamSitting.new }

  describe "#unanswered_questions" do
    specify do
      questions = subject.unanswered_questions exam_sitting
      questions.should =~ Question.all
    end

    specify do
      attrs = {question: exam_sitting.questions.first}

      exam_sitting.question_responses.create!(attrs) do |q|
        q.guesses.build answer: q.possible_answers.first
      end

      answered = subject.unanswered_questions exam_sitting
      answered.should =~ [Question.last]
    end
  end
end
