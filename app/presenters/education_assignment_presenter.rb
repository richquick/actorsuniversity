class EducationAssignmentPresenter
  #e.g. assign lesson to course
  def initialize assignment, assign_to_type, assignee_type
    @assignment = assignment

    #e.g. course
    @assign_to = assignment.send assign_to_type
    raise ArgumentError unless @assignment && @assign_to

    #e.g. lesson
    @assignee_type = assignee_type
  end

  def to_type
    #e.g. Course
    @assign_to.class.name.underscore
  end

  def select_options
    #e.g. other_courses
    others = @assignment.send(:"other_#{to_type}s")

    #e.g. Course
    klass = to_type.camelize.constantize

    #e.g. (Course.all - others).map{|o| o.name, o.id ]}
    (klass.all - others).map{|o| [o.send(title_method), o.id ]}
  end

  def title
    #e.g. course.name
    @assign_to.send(title_method)
  end

  def title_method
    [User, Group].each do |m|
      return :name if @assign_to.is_a?(m)
    end

    :title
  end
end
