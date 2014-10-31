require 'capybara_helper'

feature "Tagging,", type: :feature do
  specify "admin tagging a lesson" do
    course = Fabricate :course_with_lesson
    lesson = course.lessons.first
    sign_in :admin

    visit "/admin/lessons/#{lesson.id}/edit"

    fill_in "Tags", with: "good, bad, not ugly"

    click_button "Save Lesson"

    visit "/lessons/#{lesson.id}"

    within ".lesson .tags.links" do
      page.should have_content "good"
      page.should have_content "bad"
      page.should have_content "not ugly"
    end

    visit "/admin/courses/#{course.id}/edit"

    fill_in "course_tag_list", with: "ok, nice, lots of fun"

    click_button "Save"

    visit "/courses/#{course.id}"

    within ".course .tags.links" do
      page.should have_content "ok"
      page.should have_content "nice"
      page.should have_content "lots of fun"
    end
  end

  def data_tag type
    "[data-tag-type='#{type}']"
  end

  specify "tagging self with interests and skills" do
    sign_in :user

    data_tag("interests")
    on_edit_page do
      within data_tag('interests') do
        fill_in "user_tag_list", with: "CSS, HTML, Javascript"
        click_button "Save interests"
      end
    end

    on_edit_page do
      within data_tag('skills') do
        fill_in "user_tag_list", with: "Ruby, Rails, Coffeescript"
        click_button "Save skills"
      end
    end

    visit "/me"

    within data_tag("interests") do
      page.should have_content "CSS"
      page.should have_content "HTML"
      page.should have_content "Javascript"
    end

    within data_tag('skills') do
      page.should have_content "Ruby"
      page.should have_content "Rails"
      page.should have_content "Coffeescript"
    end
  end

  def on_edit_page
    visit "/me/edit"
    yield
  end
end
