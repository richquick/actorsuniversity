require 'spec_helper'

describe Admin::EducationAssignmentsController, type: :controller do
  render_views

  let(:admin) { Fabricate :admin }
  let(:exam) { Fabricate :exam }
  let(:course) { Fabricate :course }

  before do
    sign_in_with_double admin
  end

  specify "assign course to existing exam" do
    get :new,  assignee_type: :exam, assign_to_type: :course, assignee_id: exam.id
    response.should be_success
    controller.assignment.exam.should == exam
    controller.assignment.course.should be_new_record
  end

  specify "assign exam to existing course" do
    sign_in_with_double admin

    get :new, assignee_type: :course, assign_to_type: :exam, assignee_id: course.id
    response.should be_success
    controller.assignment.exam.should be_new_record
    controller.assignment.course.should == course
  end

  context "validating params" do
    render_views false
    let(:dao) { double('dao').as_null_object }
    before do
      controller.stub(:dao).and_return dao
    end

    #get "assign/new/:assignee_type/to/:assign_to_type/:assignee_id"
    valid_params = [
      {assignee_type: :exam,   assign_to_type: :course, assignee_id: 1},
      {assignee_type: :course, assign_to_type: :group, assignee_id: 1},
      {assignee_type: :course, assign_to_type: :group, assignee_id: "1"},
      {assignee_type: :group, assign_to_type: :user, assignee_id: "1"},
      {assignee_type: :user, assign_to_type: :group, assignee_id: "1"}
    ]

    valid_params.each do |params|
      context "with valid attributes: #{params}" do
        specify "success" do
          get :new, params
          response.should be_success
        end
      end
    end
  end
end
