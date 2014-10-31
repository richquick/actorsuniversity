require 'fast_spec_helper'
require './app/services/lesson_administration'

describe LessonAdministration do
  let(:lesson)    { double 'lesson', valid?: true }
  let(:dao)       { double 'Lesson', create_lesson_with_saved_resource: lesson }
  let(:framework) do
    double 'framework', create_success: nil, create_failure: nil
  end

  let(:lesson_administration) { LessonAdministration.new framework, dao }
  let(:token) { "some token" }

  context "save with valid lesson attributes" do
    let(:lesson_attributes) do
      { title: "some lesson title", description: "some lesson description" }
    end

    describe "persistence" do
      it "associates the uploaded resource" do
        lesson_administration.create lesson_attributes, token

        expect(dao).to have_received(:create_lesson_with_saved_resource).
                      with(lesson_attributes, token)
      end
    end

    [
      {valid: true,  expected_method: :create_success},
      {valid: false, expected_method: :create_failure}
    ].each do |spec_details|
      validity = spec_details[:valid]
      context_name = validity ? "with valid attributes" : "with invalid attributes"
      expected_method = spec_details[:expected_method]

      context context_name do
        before do
          lesson.stub(:valid?).and_return validity
        end

        it "triggers #{expected_method} in the framework" do
          lesson_administration.create lesson_attributes, token

          expect(framework).to have_received(expected_method).with lesson
        end
      end
    end
  end
end
