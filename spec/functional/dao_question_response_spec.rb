require 'spec_helper'

describe Dao::QuestionResponse do
  let!(:exam) { Fabricate :exam_with_questions }
  let!(:exam_sitting) { Fabricate :exam_sitting }
  let(:exam_sitting_id) { ExamSitting.first.id }
  let(:question) { exam_sitting.questions.first }

  let(:question_response) { Dao::QuestionResponse.new exam_sitting_id, question.id }

  describe "#next_question" do
    specify do
      question_response.next_question.should == [exam_sitting, question]
    end
  end
end
