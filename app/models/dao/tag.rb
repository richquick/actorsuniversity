module Dao
  class Tag
    def tag_lesson user, tags, id
      lesson = find_lesson(id)
      user.tag(lesson, :with => tags, on: :tags) unless tags.blank?
      lesson
    end

    def tag_course user, tags, id
      course = find_course(id)
      user.tag(course, :with => tags, on: :tags) unless tags.blank?
      course
    end

    def find_course id
      ::Course.find id
    end

    def find_lesson id
      ::Lesson.find id
    end
  end
end
