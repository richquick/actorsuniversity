require 'capybara_helper'

feature "education admin", type: :feature do
  given!(:group) { Fabricate :group}
  given!(:course) { Fabricate :course}

  scenario "From group index page" do
    as(:admin) do
      add_group_to_course_from_groups_page
    end
  end

  def add_group_to_course_from_groups_page
    visit "/admin/groups"

    within "#group_#{group.id}" do
      click_on "Assign course"
    end

    current_path.should == "/admin/assign/group/#{group.id}/to/course"

    select course.title, from: t(".admin.education_assignments.new.course")
    date = Time.now + 1.day
    fill_in "Complete by date", with: date
    fill_in "Complete within", with: 2.weeks

    click_on "Assign to course"

    course.reload
    course.groups.should include group
  end


  def add_user_to_group_from_group_page
    visit "/admin/groups/#{group.id}"

    click_on t("admin.groups.group.enrol_user")

    current_path.should == "/admin/groups/#{group.id}/education_assignments/new/user"

    select group.name, from: t(".admin.education_assignments.new.group")
    click_on t(".admin.education_assignments.new.add_to_group")

    page.current_path.should == "/admin/courses"

    visit "/admin/courses/#{course.id}"
    page.should have_content group.name

  end
end
