module Dao
  class LessonCompletion
    def for start_date, end_date
      ::LessonCompletion.
        where(created_at: start_date..end_date).
        includes(:user, :lesson)
    end
  end
end
