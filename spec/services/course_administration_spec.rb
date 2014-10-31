require 'fast_spec_helper'
require './app/services/course_administration'

describe CourseAdministration do
  let(:course)    { double 'course', valid?: true }
  let(:dao)       { double 'Dao', update_course: course }

  let(:framework) do
    double 'framework', update_success: nil, update_failure: nil
  end

  let(:course_administration) do
    CourseAdministration.new framework, dao 
  end

  context "save with valid course attributes" do
    let(:course_attributes) do
      { title: "some course title", description: "some course description" }
    end

    describe "persistence" do
      it "associates the uploaded resource" do
        course_administration.update course_attributes

        expect(dao).to have_received(:update_course).
                      with(course_attributes)
      end
    end

    it "callback to framework" do
      course_administration.update course_attributes

      expect(framework).to have_received(:update_success).
        with(course)
    end

  end
end


