class Exam < ActiveRecord::Base
  acts_as_taggable

  has_many :allocation_course_to_exams,
    class_name: "Allocation::CourseToExam"
  has_many :courses, through: :allocation_course_to_exams
  has_many :groups, through: :courses

  validates :title, :description, presence: true

  accepts_nested_attributes_for :allocation_course_to_exams,
    allow_destroy: true

  has_many :questions
  accepts_nested_attributes_for :questions, allow_destroy: true

  has_many :answers, through: :questions

  has_many :exam_sittings
  has_many :unfinished_exam_sittings, -> { where(completed: nil) },
    class_name: "ExamSitting"

  validate :already_finalized?

  validate :require_at_least_one_question

  def no_attempts?
    exam_sittings.count == 0
  end

  def finalize!
    update_attributes(finalized: true)
  end

  private

  def already_finalized?
    return false if currently_finalizing?

    if finalized? and changed?
      changes.each do |field, (_, _)|
        errors[field] << "Can't update this exam, it has already been finalized"
      end
      true
    end
  end

  def currently_finalizing?
    changes[:finalized] == [nil, true]
  end

  def require_at_least_one_question
    if currently_finalizing? || finalized?
      errors.add(:questions, "Must have at least one question") if questions.count < 1
    end
  end
end
