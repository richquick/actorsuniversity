class Allocation::CourseToGroup < ActiveRecord::Base
  belongs_to :course, -> {with_pseudo }
  belongs_to :group, -> { with_pseudo }

  validates :course, :group, presence: true
  validates :course, :uniqueness => {:scope => :group_id}
  validates :group,  :uniqueness => {:scope => :course_id}

  def user
    if group.pseudo?
      group.users.first
    else
      raise 'Unexpected lookup of user from non-pseudo group'
    end
  end

  def other_groups
    course.groups
  end

  def other_courses
    if group
      group.courses
    else
      []
    end
  end
end
