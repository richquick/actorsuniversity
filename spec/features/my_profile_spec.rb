require 'capybara_helper'

feature "Editing my profile", type: :feature do
  scenario "editing my profile" do
    sign_in :user
    visit "/me/edit"
    bio = "All about me, and the things I like"
    mobile_number = "07507134973"
    linkedin_url = "https://www.linkedin.com/pub/jack-silver/97/602/410"
    twitter_handle = "jacksilver"

    fill_in "Bio", with: bio
    fill_in "user[user_phone_numbers_attributes][0][number]",
      with: mobile_number

    select "Linkedin", from: "user[user_links_attributes][0][link_type]"
    fill_in "user[user_links_attributes][0][url]",
      with: linkedin_url

    within ".last.save.button.for.user" do
      click_on "Update User"
    end

    page.current_path.should == "/me"
    page.should have_content bio
    #page.should have_link "Twitter", href: "https://twitter.com/jacksilver"

    page.should have_link("Linkedin", href: linkedin_url)
  end
end


