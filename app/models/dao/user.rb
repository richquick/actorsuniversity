module Dao
  class User
    def upcoming_courses_to_complete_for user, time_scale = 1.week
      #TECHDEBT - this whole method
      deadline = Time.now + time_scale

      allocations = ::Allocation::CourseToGroup.
        includes(:course, :group => :users).
        references(:users).
        where(["users.id = ? ", user.id]).
        where(["complete_by_date < ?", deadline]).
        order("complete_by_date")

      completed = ::Course.completed_by(user)

      allocations.reject { |a| completed.include? a.course }
    end

    def people_i_may_want_to_follow(user)
      ::User.all - [user] - user.pursueds
    end

    def courses_to_do user
      course_ids = user.courses.map(&:id)

      courses = ::Course.where(id: course_ids)

      courses
    end

    def lessons_to_do user
      lesson_ids = user.lessons.map(&:id)

      ::Lesson.where(id: lesson_ids).
        includes(:lesson_completions).
        references(:lesson_completions).
        where("lesson_completions.lesson_id IS NULL")
    end

    def lesson_completions_by user
      user.lesson_completions.includes(:lesson)
    end

    def lessons_completed_by user
      lesson_completions_by(user).map(&:lesson)
    end

    def create attributes
      ::User.create attributes
    end

    def new
      ::User.new
    end

    def all
      ::User.all
    end

    def find id
      ::User.find id
    end

    def update id, attributes
      find(id).tap do |g|
        g.update_attributes attributes
      end
    end

    def destroy id
      ::User.destroy(id)
    end
  end
end
