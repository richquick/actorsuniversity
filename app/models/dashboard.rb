class Dashboard
  attr_reader :user, :dao

  def initialize user
    @dao = Dao::User.new
    @user = user
  end

  def upcoming_courses_to_complete
    course_allocations = dao.upcoming_courses_to_complete_for user

    course_allocations.map do|a|
      CourseAllocationDecorator.new a
    end
  end

  def people_i_may_want_to_follow
    Dao::User.new.people_i_may_want_to_follow(user)[0..4]
  end

  def users_list
    if users = user.pursueds
      users
    else
      User.find(User.pluck(:id).sample(4))
    end
  end

  def groups_list
    groups = user.groups

    if groups.any?
      groups
    else
      Group.find(Group.pluck(:id).sample(4))
    end
  end

  def courses_i_may_like
    Dao::Course.new.suggested_courses_for(user)
  end

  def lessons_to_do
    #TECHDEBT - don't decorate here
    LessonsDecorator.decorate dao.lessons_to_do user
  end

  def completed_lessons
    LessonsDecorator.decorate dao.lessons_completed_by user
  end
end
