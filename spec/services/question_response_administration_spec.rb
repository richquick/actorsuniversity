#Uncomment and use a separate faster spec helper
#require 'fast_spec_helper' # i.e. don't load framework
#require './app/services/question_response_administration'
#or use zeus https://github.com/burke/zeus and have the framework pre-loaded:
require 'spec_helper'

describe QuestionResponseAdministration do
  let(:question_response)    { double 'question_response', valid?: validity, destroy: nil }
  let(:validity) { true }
  let(:score) { double 'score' }
  let(:guesses) { double 'guesses' }

  before do
    QuestionScoreCalculator.stub(:calculate_score).and_return [score, guesses]
  end

  let(:dao) do
    double 'dao_question_response',
      get_answers:               nil,
      create_question_response:  question_response,
      update_question_response:  question_response,
      find_question_response:    question_response,
      new_question_response:     question_response,
      destroy_question_response: question_response,
      all_question_responses:    [question_response]
  end

  let(:framework) do
    double 'framework',
      success_exam_complete: nil,
      success_next_question: nil,
      create_failure: nil,
      update_success: nil,
      update_failure: nil
  end

  let(:question_response_administration) { QuestionResponseAdministration.new framework, dao }

  let(:question_response_attributes) do
    {}
  end

  describe "#answer_question" do
    before do
      dao.stub(:next_question).and_return [exam_sitting, next_question]
      question_response_administration.answer_question guesses
    end

    let(:next_question) { double 'question' }
    let(:exam_sitting) { double 'exam sitting' }

    it "creates the question_response" do
      expect(dao).to have_received(:create_question_response).with(score, guesses)
    end

    context "with valid attributes" do
      let(:validity) { true }

      it do
        expect(framework).to have_received(:success_next_question).
          with exam_sitting, next_question
      end

      context "when there are no more questions" do
        let(:next_question) { nil }

        it do
          expect(framework).to have_received(:success_exam_complete).
            with exam_sitting
        end
      end
    end

    context "with invalid attributes" do
      let(:validity) { false }

      it do
        expect(framework).to have_received(:create_failure).with question_response
      end
    end
  end

  describe "#all" do
    it "looks up the resource" do
      question_response_administration.all

      expect(dao).to have_received(:all_question_responses)
    end
  end

  describe "#edit" do
    it "looks up the resource" do
      question_response_administration.edit 1

      expect(dao).to have_received(:find_question_response).
        with(1)
    end
  end

  describe "#new_question_response" do
    it "looks up the resource" do
      question_response_administration.new_question_response

      expect(dao).to have_received(:new_question_response)
    end
  end

  describe "#destroy" do
    it "destroys the resource" do
      question_response_administration.destroy 1

      expect(dao).to have_received(:destroy_question_response).
        with 1
    end
  end

  describe "#update" do
    it "updates the resource" do
      question_response_administration.update 1, question_response_attributes

      expect(dao).to have_received(:update_question_response).
        with(1, question_response_attributes)
    end

    context "with valid attributes" do
      before do
        question_response.stub(:valid?).and_return true
      end

      it "triggers :update_success in the framework" do
        question_response_administration.update 1, question_response_attributes

        expect(framework).to have_received(:update_success).with question_response
      end
    end

    context "with invalid attributes" do
      before do
        question_response.stub(:valid?).and_return false
      end

      it "triggers :update_failure in the framework" do
        question_response_administration.update 1, question_response_attributes

        expect(framework).to have_received(:update_failure).with question_response
      end
    end
  end
end
