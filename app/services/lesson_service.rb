class LessonService < ServiceForUser
  def completed?
    lesson_completion.present?
  end

  def initialize framework, dao, user, lesson_id
    super framework, dao, user

    @lesson_id = lesson_id
  end

  def lesson
    @lesson ||= present model
  end

  def model
    @model ||= dao.find @lesson_id
  end

  def completed_at
    lesson_completion.created_at
  end

  private

  def present(lesson)
    LessonPresenterSelector.for lesson
  end

  def lesson_completion
    @lesson_completion ||= LessonCompletion.where(
      lesson_id: @lesson.id,
      user_id: @user.id
    ).first
  end

end
