require 'capybara_helper'

feature "commenting on a lesson", type: :feature do
  given!(:lesson) { Fabricate :lesson}

  scenario "Commenting on a lesson" do
    as(:user) do
      comment_on_lesson

      view_comment
    end
  end


  def comment_on_lesson
    visit lesson_path lesson

    fill_in "Comment", with: "Nice lesson"
    click_on "Post comment"
  end

  def view_comment
    visit lesson_path lesson

    page.should have_content "Nice lesson"
  end
end

