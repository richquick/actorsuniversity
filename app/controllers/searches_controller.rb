class SearchesController < ApplicationController
  def index
    @lessons = decorate_all lessons

    if @lessons.none?
      @alternative = decorate_all alternative
    end
  end

  private

  def decorate_all results
    results.map{|l| decorate l }
  end

  def decorate l
    LessonPresenterSelector.for l
  end

  def lessons
    @query = params[:search][:search]

    scope(Lesson)
  end

  def scope klass
    klass.where(title: @query) +

    klass.all.includes(:tags).
      references(:tags).
      where("tags.name in (?)", @query)
  end

  def alternative
    Lesson.all
  end
end
