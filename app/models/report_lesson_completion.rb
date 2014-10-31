class ReportLessonCompletion
  include FormBacker
  include Virtus

  attribute :start_date, DateTime
  attribute :end_date, DateTime

  def filename
    "lesson_completions_#{format start_date}_#{format end_date}"
  end

  def lesson_completions
    dao.for start_date, end_date
  end

  def format t
    t.strftime("%b-%d-%Y")
  end

  def dao
    @dao ||= Dao::LessonCompletion.new
  end
end
