class Chart
  def users_logged_in from, to
    (last_signed_in_users(from, to) +
     current_signed_in_users(from, to)).uniq
  end

  def current_signed_in_users from, to
    User.where(:last_sign_in_at => (from..to))
  end

  def last_signed_in_users from, to
    User.where(:last_sign_in_at => (from..to))
  end

  def users_not_logged_in from, to
    User.all -
      current_signed_in_users(from, to) -
      last_signed_in_users(from, to)
  end

  def users_completed from, to
    LessonCompletion.
      where(:created_at => (from..to)).
      includes(:user).map(&:user)
  end

  def users_not_logged_in from, to
    LessonCompletion.
      where(:created_at => (from..to)).
      includes(:user).map(&:user)
  end

  def lessons_completed from=nil, to=nil
    lesson_completions = User.all.
      includes(:lesson_completions)

    if from and to
      lesson_completions =
        lesson_completions.
        references(:lesson_completions).
        where(["lesson_completions.created_at > ?", from]).
        where(["lesson_completions.created_at < ?", to])
    end

    lesson_completion_counts = lesson_completions.map{|u| u.lesson_completions.size }

    result = {}
    lesson_completion_counts.uniq.each do |c|
      count = lesson_completion_counts.count(c)
      users = "user".pluralize(count)
      result["#{count} #{users} ="] = c
    end

    result.to_a.sort{|a,b| a[1] <=> b[1]}
  end

  def first_lesson_completion_date
    lesson_creations_by_date.first.first
  end

  def lesson_completions_by_date
    @lesson_completions_by_date ||= grouped_by_date LessonCompletion
  end

  def first_lesson_creation_date
    lesson_creations_by_date.first.first
  end

  def lesson_creations_by_date
    @lesson_creations_by_date ||= grouped_by_date Lesson
  end

  private

  def grouped_by_date klass
    klass.all.
      order(:created_at).
      group_by{|l| l.created_at.beginning_of_day }.
      map do |date, matched|
        [to_js_date(date), matched.count ]
      end
  end

  def to_js_date date
    [date.year, date.month - 1, date.day ]
  end
end
