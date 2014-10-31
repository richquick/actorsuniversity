class Allocation::LessonToCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :lesson
  validates :course, :lesson, presence: true
  validates :course, :uniqueness => {:scope => :lesson_id}
  validates :lesson, :uniqueness => {:scope => :course_id}

  def other_courses
    lesson.courses
  end

  def other_lessons
    course.lessons
  end
end
