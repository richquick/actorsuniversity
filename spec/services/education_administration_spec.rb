require 'fast_spec_helper'
require './app/services/education_administration'

describe EducationAdministration do
  let(:framework) do
    double 'framework', create_success: nil, create_failure: nil
  end

  let(:assignment) { double 'assignment', valid?: true }

  let(:dao) {
    double 'Dao',
    assign_course_to_exam:   assignment,
    assign_user_to_group:    assignment,
    assign_course_to_group:  assignment,
    assign_lesson_to_course: assignment,
    assign_user_to_course:   assignment,
    assign_lesson_to_user:   assignment,
    assign_lesson_to_group:  assignment,

    new_assignment_user_to_group:    assignment,
    new_assignment_course_to_group:  assignment,
    new_assignment_lesson_to_course: assignment,
    new_assignment_user_to_course:   assignment,
    new_assignment_lesson_to_user:   assignment,
    new_assignment_lesson_to_group:  assignment

  }

  let(:administrator) do
    EducationAdministration.new framework, dao
  end

  describe "#assign" do
    attrs = [
      {course: 1, user: 2, with: "unrequired"},
      {course: 1},
      {group: 1,  course: {non: "numeric"}}
    ]

    attrs.each do |attributes|
      context "with invalid attributes: #{attributes}" do
        specify "raise an ArgumentError" do
          action = ->{administrator.assign(attributes)}

          expect(action).to raise_error ArgumentError
        end
      end
    end
  end

  describe "#new_assignment" do
    context "for direct data relationships" do
      describe "assigning lessons to courses" do
        before do
          administrator.assign(lesson: 1, course: 2)
        end

        it do
          expect(dao).to have_received(:assign_lesson_to_course).with(1, 2)
        end

        it "notifies of success" do
          expect(framework).to have_received(:create_success).with(assignment)
        end
      end

      describe "assigning courses to groups" do
        it do
          administrator.assign(course: 1, group: 2)
          expect(dao).to have_received(:assign_course_to_group).with(1, 2)
        end
      end

      describe "assigning courses to exam" do
        it do
          administrator.assign(course: 1, exam: 2)
          expect(dao).to have_received(:assign_course_to_exam).with(1, 2)
        end
      end

      describe "assigning users to groups" do
        it do
          administrator.assign(user: 1, group: 2)
          expect(dao).to have_received(:assign_user_to_group).with(1, 2)
        end
      end
    end

    context "for pseudo data relationships" do
      describe "assigning users to courses" do
        it do
          administrator.assign(user: 1, course: 2)
          expect(dao).to have_received(:assign_user_to_course).with(1, 2)
        end
      end

      describe "assigning lessons to users" do
        it do
          administrator.assign(lesson: 1, user: 2)
          expect(dao).to have_received(:assign_lesson_to_user).with(1, 2)
        end
      end
      describe "assigning lessons to groups" do
        it do
          administrator.assign(lesson: 1, group: 2)
          expect(dao).to have_received(:assign_lesson_to_group).with(1, 2)
        end
      end
    end
  end
end
