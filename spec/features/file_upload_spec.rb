require 'capybara_helper'

feature "File upload", type: :feature do
  include CarrierWaveDirect::Test::CapybaraHelpers

  background do
    visit "/admin/users"
    sign_in :admin
  end

  it "Uploading a file" do
    visit "/admin/lessons/new"

    save_fixture_for_jasmine("file_upload")
    fill_in "Title", with: "Some title"
    fill_in "Description", with: "Some description"


    pending "Work out some way to test this properly, (or eliminate this async file upload idea?)"
    attach_file("resource_file_resource_file", 'spec/support/csv_fixture.csv')

    click_on "Upload File"
    click_on "Save Lesson"

    page.should have_content "Lesson saved"
  end
end
