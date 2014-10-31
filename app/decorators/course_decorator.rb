class CourseDecorator < Draper::Decorator
  delegate_all

  def lessons
    object.lessons.map{|l| decorate_lesson l }
  end

  def thumbnail
    image.url(:web, :preview) || lessons.sample.try(:preview)
  end

  def decorate_lesson l
    LessonPresenterSelector.for l
  end
end
