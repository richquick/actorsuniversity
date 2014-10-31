class Allocation::UserToGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates :user, presence: true

  def other_groups
    user.groups
  end

  def other_users
    group.users
  end

  def other_courses
    user.courses
  end
end
