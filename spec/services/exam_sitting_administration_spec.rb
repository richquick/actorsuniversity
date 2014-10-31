#Uncomment and use a separate faster spec helper  
#require 'fast_spec_helper' # i.e. don't load framework
#require './app/services/exam_sitting_administration'
#or use zeus https://github.com/burke/zeus and have the framework pre-loaded:
require 'spec_helper' 

describe ExamSittingAdministration do
  let(:exam_sitting)    { double 'exam_sitting', valid?: validity }
  let(:question) { double 'question' }
  let(:validity) { true }

  let(:dao) do 
    double 'dao_exam_sitting', 
      create_exam_sitting:  exam_sitting,
      update_exam_sitting:  exam_sitting,
      find_exam_sitting:    exam_sitting,
      new_exam_sitting:     exam_sitting,
      destroy_exam_sitting: exam_sitting,
      all_exam_sittings:    exam_sitting,
      first_question_for:   question
  end

  let(:framework) do
    double 'framework', 
      create_success: nil,
      create_failure: nil,
      update_success: nil,
      update_failure: nil
  end

  let(:exam_sitting_administration) { ExamSittingAdministration.new framework, dao, user_id }
  let(:user_id) { 1 }
  let(:exam_id) { 1 }

  let(:exam_sitting_attributes) do
    {exam_id: exam_id, user_id: user_id}
  end

  describe "#new_exam_sitting" do
    it "looks up the resource" do
      exam_sitting_administration.new_exam_sitting exam_id

      expect(dao).to have_received(:new_exam_sitting)
    end
  end

  describe "#create" do
    it "creates the resource" do
      exam_sitting_administration.create exam_id

      expect(dao).to have_received(:create_exam_sitting).
                    with(exam_sitting_attributes)
    end

    context "with valid attributes" do
      let(:validity) { true }

      it "triggers :create_success in the framework" do
        exam_sitting_administration.create exam_sitting_attributes

        expect(framework).to have_received(:create_success).with exam_sitting, question
      end
    end

    context "with invalid attributes" do
      let(:validity) { false }

      it "triggers :create_failure in the framework" do
        exam_sitting_administration.create exam_sitting_attributes

        expect(framework).to have_received(:create_failure).with exam_sitting, question
      end
    end
  end
end
