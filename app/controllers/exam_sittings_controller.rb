class ExamSittingsController < ApplicationController
  decorates_assigned :exam_sitting

  def new
    @exam_sitting = administrator.new_exam_sitting params[:exam_id]
  end

  def show
    @exam_sitting = administrator.find params[:id]

    unless @exam_sitting.completed?
      question = @exam_sitting.first_unanswered_question
      path = new_exam_sitting_question_question_response_path(@exam_sitting, question)
      redirect_to path
    end
  end

  def create
    @exam_sitting = administrator.create params[:exam_id]
  end

  def create_success exam_sitting, first_question
    redirect_to new_exam_sitting_question_question_response_path exam_sitting, first_question
  end

  private

  def administrator
    @administrator ||= ExamSittingAdministration.new(self, Dao::ExamSitting.new, current_user.id)
  end
end
