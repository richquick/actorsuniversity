require 'capybara_helper'

feature "Following users", type: :feature do
  given!(:labowski) { Fabricate :user, name: "The Dude", email: "user_2@example.com" }

  scenario do
    me = sign_in :user

    visit user_path labowski
    click_on "Follow"

    visit user_path me

    within ".timeline.of.followers .pursueds" do
      page.should have_content "The Dude"
    end
  end
end


