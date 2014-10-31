module CoursesHelper
  def completed? lesson
    current_user.
      lesson_completions.
      include? completion_for(lesson)
  end

  def completion_for lesson
    LessonCompletion.where(
      lesson_id: lesson.id,
      user_id: current_user.id).first
  end
end
