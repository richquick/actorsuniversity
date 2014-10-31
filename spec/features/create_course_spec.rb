require 'capybara_helper'

feature "Admin creating a lesson", type: :feature do
  given!(:lesson)  { Fabricate :lesson }

  let(:course_title) { "Some course title" }
  let(:course_description) { "Some course title" }

  specify "create a course" do
    sign_in :admin
    visit "/admin/courses/new"
    fill_in "Title", with: course_title
    fill_in "Description", with: course_description

    click_on "Save Course"

    page.status_code.should == 200

    page.should have_content course_title
    page.should have_content course_description

    visit admin_lessons_path

    click_on "Add to course"
    select course_title, from: "Course"
    click_on "Assign to course"

    current_path.should == admin_lessons_path

    visit course_path(Course.last)

    within ".summaries.for.lessons" do
      page.should have_content lesson.title
    end
  end
end
