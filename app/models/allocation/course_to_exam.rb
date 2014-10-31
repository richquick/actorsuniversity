class Allocation::CourseToExam < ActiveRecord::Base
  belongs_to :course
  belongs_to :exam

  def other_courses
    exam.courses
  end

  def other_exams
    course.exams
  end

end
