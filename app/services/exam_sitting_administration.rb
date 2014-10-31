class ExamSittingAdministration
  include Hexagonal

  def initialize framework, dao, user_id
    super framework, dao
    @user_id = user_id
  end

  def new_exam_sitting exam_id
    dao.new_exam_sitting exam_id
  end

  def find exam_sitting_id
    dao.find_exam_sitting exam_sitting_id
  end

  def create exam_id
    exam_sitting = dao.create_exam_sitting(exam_id: exam_id, user_id: @user_id)

    meth = exam_sitting.valid? ? :create_success : :create_failure

    framework.send meth, exam_sitting, dao.first_question_for(exam_sitting)
  end
end
