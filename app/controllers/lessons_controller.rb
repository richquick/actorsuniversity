class LessonsController < ApplicationController
  helper_method :completed?, :lesson_completion

  def index
    @lessons = current_user.lessons.map{|l| present l }
  end

  def show
    @lesson = lesson_service.lesson
  end

  private

  def present(lesson)
    LessonPresenterSelector.for lesson
  end


  def lesson_service
    @lesson_service ||= LessonService.new self, dao, current_user, params[:id]
  end

  def dao
    ::Lesson
  end
end
