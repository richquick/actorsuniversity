class LessonAdministration
  include Hexagonal

  def new_lesson
    @new_lesson ||= dao.new_lesson
  end

  def create lesson_attributes, token
    lesson = dao.create_lesson_with_saved_resource(lesson_attributes, token)

    if lesson.valid?
      framework.create_success(lesson)
    else
      framework.create_failure(lesson)
    end
  end

  def edit id
    dao.find_lesson_including_resource id
  end

  def update user, id, attributes
    lesson = dao.update_lesson_including_tags user, id, attributes

    if lesson.valid?
      framework.update_success(lesson)
    else
      framework.update_failure(lesson)
    end
  end
end
