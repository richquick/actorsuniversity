class Course < ActiveRecord::Base
  has_many :allocation_lesson_to_courses,
    class_name: "Allocation::LessonToCourse"
  has_many :lessons, through: :allocation_lesson_to_courses

  has_many :allocation_course_to_groups,
    class_name: "Allocation::CourseToGroup"
  has_many :groups, through: :allocation_course_to_groups

  has_many :users, through: :groups

  has_many :allocation_course_to_exams,
    class_name: "Allocation::CourseToExam"

  has_many :exams,
    -> { where finalized: true },
    through: :allocation_course_to_exams

  mount_uploader :image, ImageUploader

  def users
    groups.with_pseudo.map(&:users).flatten
  end

  def self.completed_by user
    with_completed_status(user) do |progress|
      progress == 100
    end
  end

  def self.not_completed_yet user
    with_completed_status(user) do |progress|
      progress != 100
    end
  end

  def self.with_completed_status user
    user.courses.
      select{|c| yield completed_lesson_percentage_for(user, c) }
  end

  #should probably move into it's own object
  def self.completed_lesson_percentage_for user, course
    lessons_count = course.lessons.count
    return 0 if lessons_count == 0

    100.0 * completed_lesson_count_for(user, course) / lessons_count
  end

  def self.completed_lesson_count_for user, course
    dao = Dao::User.new

    dao.lesson_completions_by(user).
      includes(:lesson => :allocation_lesson_to_courses).
      references(:allocation_lesson_to_courses).
      where("allocation_lesson_to_courses.course_id = ?", course.id).
      count
  end

  extend PseudoRelationship

  def self.groups_with_pseudo
    groups.with_pseudo
  end

  def self.users
    groups_with_pseudo.map(&:users).flatten
  end


  acts_as_taggable
  validates :title, :description, presence: true
  letsrate_rateable :difficulty, :enjoyment

  def enrol! user
    course_enrolments.create!(user: user)
  end
end
