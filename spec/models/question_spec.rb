require 'spec_helper'

describe Question do
  let(:question) { Question.new }
  before do
    question.valid?
  end

  specify do
    question.errors[:answers].should == 
      ["Need at least two answers",
       "Need at least one correct answer"]
  end

  specify do
    question.answers << Answer.new(text: "an answer", correct: true)

    question.valid?
    question.errors[:answers].should_not include "Need at least one correct answer"
  end

  specify do
    question.answers << Answer.new(text: "an answer")
    question.answers << Answer.new(text: "another answer")

    question.valid?
    question.errors[:answers].should_not include "Need at least two answers"
  end
end

