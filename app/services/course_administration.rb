class CourseAdministration
  include Hexagonal

  def update course_attributes
    course = dao.update_course course_attributes

    meth = course.valid? ? :update_success : :update_failure
    framework.send meth, course
  end

end
