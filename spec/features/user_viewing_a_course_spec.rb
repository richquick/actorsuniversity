
require 'capybara_helper'

feature "Editing my profile", type: :feature do
  given!(:course)  { Fabricate :course_with_lesson }
  given!(:group)  { Fabricate :group }

  scenario "editing my profile" do
    user = sign_in :user
    group.courses << course
    user.groups << group

    click_on "Courses"

    within "ul.courses" do
      page.should have_content course.title
      page.should have_content course.description
    end

    click_on course.title

    lesson = course.lessons.first

    page.should have_content lesson.title

    click_on "Take Lesson"

    current_path.should == lesson_path(lesson)
    page.should have_content lesson.description
  end
end


