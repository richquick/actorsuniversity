module Admin
  class Dashboard
    def least_enjoyable
      enjoyment_ratings(:asc)
    end

    def most_enjoyable
      enjoyment_ratings(:desc)
    end

    def least_popular_lessons
      popular_lessons("ASC")
    end

    def most_popular_lessons
      popular_lessons("DESC")
    end

    def villains
      user_lesson_completions("ASC")
    end

    def heroes
      user_lesson_completions("DESC")
    end

    def lesson_completion_report
      ReportLessonCompletion.new(start_date: Time.now - 1.month, end_date: Time.now)
    end

    private

    def user_lesson_completions order
      LessonCompletion.group("user_id").
        select("user_id, count(user_id) as num_users").
        order("num_users #{order}").map(&:user).compact
    end

    def popular_lessons order
      LessonCompletion.group("lesson_id").
        select("lesson_id, count(lesson_id) as num_lessons").
        limit(5).
        order("num_lessons #{order}").map(&:lesson).compact
    end

    def enjoyment_ratings(order)
      RatingCache.where(cacheable_type: "Lesson",
                        dimension: "enjoyment").
                        order(:avg => order).
                        limit(5).
                        map{|r| r.cacheable }
    end


  end
end
