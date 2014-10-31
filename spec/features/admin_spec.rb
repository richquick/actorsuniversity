require 'capybara_helper'

feature "Managing users", type: :feature do
  given!(:example_user) { Fabricate :user, email: "user_2@example.com" }

  context "non-admin" do
    scenario "non-admin visiting users page" do
      sign_in :user

      visit "/admin/users"
      page.should have_content "Unauthorized"
    end
  end

  context "admin" do
    background do
      visit "/admin/users"
      page.should have_content "Sign in"

      sign_in :admin
    end

    scenario "admin visiting users page" do
      visit "/admin/users"
      page.should have_content example_user.email
    end

    scenario "create user" do
      visit "/admin/users/new"

      fill_in "Email",    with: "email@example.com"
      fill_in "Password", with: "password"
      select "admin", from: "Role"

      within '.last.save.button.for.user' do
        click_on "Create User"
      end

      visit "/admin/users"
      page.should have_content "email@example.com"
    end
  end
end

