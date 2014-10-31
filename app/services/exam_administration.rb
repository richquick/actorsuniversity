class ExamAdministration
  include Hexagonal

  def create attributes
    exam = dao.create_exam attributes

    meth = exam.valid? ? :create_success : :create_failure
    framework.send meth, exam
  end

  def update id, attributes
    exam = dao.update_exam id, attributes

    meth = exam.valid? ? :update_success : :update_failure
    framework.send meth, exam
  end

  def add_question exam_id, attributes
    question = dao.add_question exam_id, attributes

    meth = question.valid? ? :create_success : :create_failure
    framework.send meth, question
  end

  def update_question question_id, attributes
    question = dao.update_question question_id, attributes

    meth = question.valid? ? :update_success : :update_failure
    framework.send meth, question
  end
end
