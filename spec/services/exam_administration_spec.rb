require 'fast_spec_helper'
require './app/services/exam_administration'

describe ExamAdministration do
  let(:exam)    { double 'exam', valid?: true }
  let(:dao)       { double 'Dao', update_exam: exam, create_exam: exam }

  let(:framework) do
    double 'framework',
      update_success: nil,
      update_failure: nil,
      create_success: nil,
      create_failure: nil
  end

  let(:exam_administration) do
    ExamAdministration.new framework, dao 
  end

  describe "#create" do
    let(:exam_attributes) do
      {title: "some exam title", description: "some exam description" }
    end

    describe "persistence" do
      it "associates the uploaded resource" do
        exam_administration.create exam_attributes

        expect(dao).to have_received(:create_exam).
                      with(exam_attributes)
      end
    end

    it "calls success on framework" do
      exam_administration.create exam_attributes

      expect(framework).to have_received(:create_success).
        with(exam)
    end
  end

  describe "update" do
    let(:exam_attributes) do
      {title: "some exam title", description: "some exam description" }
    end

    describe "persistence" do
      it "updates the exam" do
        exam_administration.update 1, exam_attributes

        expect(dao).to have_received(:update_exam).
                      with(1, exam_attributes)
      end
    end

    it "callback to framework" do
      exam_administration.update 1, exam_attributes

      expect(framework).to have_received(:update_success).
        with(exam)
    end

  end
end


