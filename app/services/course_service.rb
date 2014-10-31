class CourseService < ServiceForUser
  def initialize framework, dao, current_user, course_id
    super framework, dao, current_user
    @course_id = course_id
  end

  def complete_by_date
    group_ids = @user.groups.map(&:id)

    allocation = Allocation::CourseToGroup.find_by(group_id: group_ids, course_id: @course_id)
    allocation.try :complete_by_date
  end

  def enroled?
    @user.courses.map(&:id).include? @course.id
  end

  def complete_exam_sittings_for exam
    sittings = exam_sittings_for exam

    sittings.where(completed: true)
  end

  def last_incomplete_exam_sitting_for exam
    sittings = exam_sittings_for exam
    sittings.where(completed: nil).try :last
  end

  def exam_sittings_for exam
    @course.exams.detect{|e| e.id == exam.id}.exam_sittings
  end

  def progress
    if enroled?
      dao.completed_lesson_percentage_for @user, course
    else
      0
    end
  end


  def course
    @course ||= dao.find(@course_id)
  end
end
