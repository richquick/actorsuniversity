require 'capybara_helper'

feature "Admin creating a lesson", type: :feature do
  specify "create a lesson" do
    sign_in :admin
    visit "/admin/lessons/new"
    fill_in "Title", with: "Some title"
    fill_in "Description", with: "Some description"
    fill_in "lesson_external_resource_url", with: "google.com"

    click_button "Save Lesson"

    within ".table.of.lessons" do
      page.should have_content "Some title"
    end
  end
end
