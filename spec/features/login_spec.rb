require 'capybara_helper'

feature "Logging in", type: :feature do
  background do
    @password = 'hung3rg4m3s'
    @user = Fabricate :user, password: @password
  end

  scenario "signing in" do
    visit "/"

    page.should have_content "Sign in"
    sign_in :user, @user.email, @password

    page.should_not have_content "Sign in"
    page.should have_content t(".dashboards.show.welcome")
  end

  scenario "spoofing a user" do
    sign_in :admin

    visit "/dashboard"

    #only admins see the graphs
    page.should have_selector "#line_graph"

    click_on t("navigation.settings.view_as_user")

    current_path.should == "/dashboard"

    page.should have_no_selector "#line_graph"

    click_on t("navigation.settings.view_as_admin")
  end
end
