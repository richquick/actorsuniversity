class Group < ActiveRecord::Base
  validates :name, :description, presence: true

  has_many :allocation_user_to_groups, 
    class_name: "Allocation::UserToGroup"
  has_many :users, through: :allocation_user_to_groups

  has_many :allocation_course_to_groups,
    class_name: "Allocation::CourseToGroup"
  has_many :courses, through: :allocation_course_to_groups

  def lessons
    courses.with_pseudo.map(&:lessons).flatten
  end

  def pseudo_lessons
    courses.pseudo.map(&:lessons).flatten
  end

  extend PseudoRelationship

  def enrol! user
    user_group_enrolments.create!(user: user)
  end
end
