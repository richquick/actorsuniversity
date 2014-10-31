require 'capybara_helper'

feature "Completing a lesson", type: :feature do
  let!(:user) { Fabricate :user }
  let!(:lesson) { Fabricate :lesson }

  scenario "Upload, tag, search for then rate a video" do
    course = lesson.pseudo_course
    group = user.pseudo_group

    allocation = Allocation::CourseToGroup.create!(group: group, course: course)

    sign_in :user, user.email, 'hung3rg4m3s'

    mark_lesson_as_complete

    view_lesson
  end


  def mark_lesson_as_complete
    visit "/lessons/#{lesson.id}"

    click_on t(".lessons.complete_lesson.mark_as_completed")
  end

  def view_lesson
    visit "/lessons/#{lesson.id}"

    within '.hero.for.lesson .meta' do
      page.text.should include "Completed"
    end
  end
end
