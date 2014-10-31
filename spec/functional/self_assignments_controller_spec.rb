require 'spec_helper'

describe SelfAssignmentsController, type: :controller do
  render_views

  let(:user) { Fabricate :user }
  let(:course) { Fabricate :course }

  before do
    sign_in_with_double user
  end

  specify "assign self to course" do
    user.courses.should be_empty
    post :create,  assign_to_type: :course, assign_to_id: course.id
    response.should redirect_to course_path course
    user.reload
    user.courses.should include course
  end
end
