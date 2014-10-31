require 'capybara_helper'

feature "Sitting an exam", type: :feature do
  given(:exam) { Fabricate(:exam_with_questions).tap &:finalize! }

  given(:course) do
    Fabricate(:course).tap do |c|
      c.exams << exam
    end
  end
  given!(:user) { sign_in :user }
  specify "happy path" do
    dao = Dao::EducationAdministration.new
    dao.assign_user_to_course user.id, course.id

    visit course_path course

    click_on exam.title
    click_on "Start exam"

    question = first_question_of ExamSitting.last
    path = new_question_path_for ExamSitting.last

    current_path.should == path

    check_answer_for question.answers.last.text
    click_on "Next question"

    check_previous_answers
  end

  def new_question_path_for sitting
    question = first_question_of ExamSitting.last
    new_exam_sitting_question_question_response_path(sitting, question)
  end

  def first_question_of sitting
    questions = sitting.exam.questions
    question = questions.first
  end

  def check_answer_for answer_text
    answer = Answer.find_by(text: answer_text)
    input = find(:xpath, "//*[@value='#{answer.id}']")

    input.set true
    input.should be_checked
  end

  def check_previous_answers
    within ".past_answers" do
      page.should have_content "Correct"
      page.should have_content "Yes"
    end
  end
end
