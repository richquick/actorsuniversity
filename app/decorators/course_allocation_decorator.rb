class CourseAllocationDecorator < Draper::Decorator
  decorates Allocation::CourseToGroup
  delegate_all

  def complete_by_date
    model.complete_by_date.strftime "%a, %e %b %Y"
  end

  def distance_of_time
    t = h.distance_of_time_in_words model.complete_by_date, Time.now

    if overdue?
      "#{t} ago"
    else
      "in #{t}"
    end
  end

  def css_class
    overdue? ? "overdue" : ""
  end

  def overdue?
    model.complete_by_date < Time.now
  end
end


