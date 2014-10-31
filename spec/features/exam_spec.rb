require 'capybara_helper'

feature "Creating an exam", type: :feature do
  given!(:exam) { Fabricate :exam }

  def messy_finder_for_nested_form_added_field
    starts_with =  'question_answers_attributes_'

    all("input[id^='#{starts_with}']").map(&:path).map do |s|
      s[/question_answers_attributes_.*_text/]
    end.compact.last
  end

  def brittle_remove_link_finder id
    path = "//*[@id=\"edit_question_#{id}\"]/ol/li[1]/a"
    find :xpath, path
  end

  specify do
    sign_in :admin

    visit new_admin_exam_path

    fill_in "Title", with: "JLPT5"
    fill_in "Description", with: "Beginner's Japanese"

    click_on t("admin.exams.form.save")

    current_path.should == new_admin_exam_question_path(Exam.last)

    within ".second.content" do
      fill_in "Question", with: "Say はじめまして politely"
      fill_in "question_answers_attributes_0_text", with: "はじみてぃヲウガナビラ"
      fill_in "question_answers_attributes_1_text", with: "初めまして"
      check "question_answers_attributes_0_correct"

      click_on t "admin.questions.form.add_question"
    end

    within ".correct" do
      page.should have_content "はじみてぃヲウガナビラ"
    end

    Exam.last.should_not be_finalized

    within ".finalize.button" do
      click_on "Finalize exam"
    end

    Exam.last.should be_finalized
  end
end

feature "Assigning a course to a exam", type: :feature do
  given!(:course) { Fabricate :course }
  given!(:exam) { Fabricate :exam_with_questions }

  specify do
    sign_in :admin

    visit admin_exams_path

    within "#exam_#{exam.id}" do
      click_on t("admin.exams.index.add_to_course")
    end

    select course.title, from: "Course"

    click_on "Assign to course"

    visit "/exams/#{exam.id}"

    within ".list.of.courses" do
      page.should have_content course.title
    end
  end
end
