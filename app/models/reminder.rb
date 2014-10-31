class Reminder
  def self.send_all host
    new.send_all host
  end

  def send_all host
    dao = Dao::User.new

    ::User.all.each do |u|
      courses = dao.upcoming_courses_to_complete_for u, 1.week

      send_email host, u, courses if courses.any?
    end
  end

  def send_email host, recipient, course_allocations
    course_allocations = course_allocations.map{|c| CourseAllocationDecorator.new c }

    ReminderMailer.
      upcoming_courses(host, recipient, course_allocations).deliver
  end
end
