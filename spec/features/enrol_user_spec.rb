require 'capybara_helper'

feature "Assigning a user to a course", type: :feature do
  given!(:example_user) { Fabricate :user, email: "user_2@example.com" }
  given!(:course) { Fabricate :course }

  scenario do
    sign_in :admin

    visit "/admin/users"

    within "#user_#{example_user.id}" do
      click_on t("admin.users.index.enrol_on_course")
    end

    current_path.should == "/admin/assign/user/#{example_user.id}/to/course"
    select course.title, from: "Course"
    click_on "Assign to course"

    visit "/admin/users/#{example_user.id}"

    within ".list.of.current.courses" do
      page.should have_content course.title
    end
  end
end
