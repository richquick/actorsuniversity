
require 'capybara_helper'

feature "Searching", type: :feature do
  scenario "searching for a lesson" do
    sign_in :user
    course = Fabricate :course_with_lesson
    lesson = course.lessons.first

    fill_in "Search", with: lesson.title
    click_on "Search"

    click_on lesson.title
    current_path.should == "/lessons/#{lesson.id}"
  end
end


