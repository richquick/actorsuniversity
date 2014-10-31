require 'capybara_helper'

feature "Demo", type: :feature do
  let(:title) { "Awesome youtube video" }
  let(:url) { "http://www.youtube.com/watch?v=5Srrn5m-C9A" }

  scenario "Upload, tag, search for then rate a video" do
    as(:admin) do
      upload_video
    end

    as(:user) do
      search_for_video

      express_interest_in_tag

      visit_dashboard

      rate_video

      view_ratings
    end

    as(:admin) do
      create_group
      add_user_to_group
      add_course_to_group
    end

    as(:user) do
      user_sees_course
    end
  end

  def upload_video
    visit "/admin/lessons/new"
    description = "This is my nice description of the video"
    tags =  ['Bribery', 'Bribery Legislation', '2010']

    fill_in "Title", with: title
    fill_in "Description", with: description
    fill_in "lesson_external_resource_url", with: url
    fill_in "Tags", with: tags.join(',')


    click_on "Save Lesson"

    visit lesson_path Lesson.last
    tags.each do |t|
      page.should have_content t
    end

    page.should have_content title
    page.should have_content description

  end

  def search_for_video
    fill_in "Search", with: "Awesome youtube video"
    click_on  "Search"

    page.should have_content title
    click_on title


    link_value = find('a',  text: 'Take lesson').native.attributes["href"].value
    link_value.should == "//www.youtube.com/embed/5Srrn5m-C9A"
  end


  def express_interest_in_tag
    visit "/me/edit"

    if false
    fill_in "Tags", with: "Bribery"
    click_on "Create Tag"
    end
  end

  def visit_dashboard
    visit "/dashboard"
  end

  def rate_video
    visit "/lessons/#{Lesson.last.id}"

    click_on "Rate 5 Stars" if false
  end

  def view_ratings
    visit "/lessons/#{Lesson.last.id}"

    page.should have_content "Average rating: 5.0" if false #TECHDEBT implement ratings
  end

  def create_group
    visit "/admin/groups/new"
    fill_in "Name", with: "A group name"
    fill_in "Description", with: "Some group description"
    check "Public"

    click_on "Save"

    page.current_path.should == "/admin/groups"

    within ".groups" do
      page.should have_content "A group name"
    end
  end

  def add_user_to_group
    user = @all_users[:user]

    visit "/admin/users"

    within "#user_#{user.id}" do
      click_on "Add to group"
    end

    select "A group name", from: t(".admin.education_assignments.new.group")
    click_on "Assign to group"

    page.current_path.should == "/admin/users"

    visit "/groups/#{Group.first.id}"
    page.should have_content user.email
  end

  def add_course_to_group
    course = Fabricate :course
    visit "/admin/courses"

    within "#course_#{course.id}" do
      click_on "Add to group"
    end

    group = Group.first

    select group.name, from: t(".admin.education_assignments.new.group")
    click_on "Assign to group"

    course.reload
    course.groups.should include group
  end

  def user_sees_course
    visit "/dashboard"

    within ".group.of.navigation.links" do
      hacky_selector_for_studiable_items.should == ["1", "0", "1"]
    end
  end

  def hacky_selector_for_studiable_items
    attributes = page.all('a').map(&:native).map(&:attributes)

    attributes.map{|a| a['data-studiable-count'].try(&:value) }.compact
  end
end
