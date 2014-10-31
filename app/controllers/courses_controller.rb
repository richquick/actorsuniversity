class CoursesController < ApplicationController
  decorates_assigned :courses, :course

  [:enroled?].each do |m|
    delegate m, to: :course_service
    helper_method m
  end

  helper_method :last_incomplete_exam_sitting_for, :complete_exam_sittings_for,
    :complete_by_date

  def index
    @courses = current_user.courses
  end

  def show
    @course = course_service.course

    @progress = course_service.progress.round 0
  end

  private

  def complete_by_date
    course_service.complete_by_date.strftime "%a, %e %b %Y"
  end

  def complete_exam_sittings_for exam
    course_service.complete_exam_sittings_for(exam).map do |s|
      ExamSittingDecorator.new s 
    end
  end

  def last_incomplete_exam_sitting_for exam
    sitting = course_service.last_incomplete_exam_sitting_for(exam)
    ExamSittingDecorator.new sitting if sitting
  end

  def enroled?
    course_service.enroled?
  end

  def course_service
    @course_service ||= CourseService.new self, dao, current_user, params[:id]
  end

  def dao
    ::Course
  end
end
