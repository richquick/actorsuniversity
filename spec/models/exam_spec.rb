require 'spec_helper'

describe Exam do
  let(:exam) do
    Fabricate :exam_with_questions
  end

  before do
    exam.finalize!
  end

  describe "#finalize" do
    specify do
      exam.should be_finalized
    end

    specify do
      exam.should be_valid
      exam.created_at = Time.now.yesterday

      exam.valid?
      exam.errors[:created_at].should == ["Can't update this exam, it has already been finalized"]
    end

    context "without questions" do
      let(:exam) { Fabricate :exam }

      specify do
        exam.valid?
        exam.errors[:questions].should == ["Must have at least one question"]
      end
    end
  end
end
