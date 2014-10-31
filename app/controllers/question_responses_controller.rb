class QuestionResponsesController < ApplicationController
  before_filter :already_answered
  decorates_assigned :question_responses, :question_response, :exam_sitting

  def index
    @question_responses = question_response_administration.all
  end

  def new
    @question_response = question_response_administration.new_question_response
    @exam_sitting = @question_response.exam_sitting
  end

  def create
    question_response_administration.answer_question Array(params[:answer_ids])
  end

  def create_failure question_response
    @exam_sitting = question_response.exam_sitting
    @question_response = question_response
    render action: 'new'
  end

  def update
    question_response_administration.answer_question Array(params[:answer_ids])
  end

  def success_next_question exam_sitting, next_question
    redirect_to new_exam_sitting_question_question_response_path exam_sitting, next_question
  end

  def success_exam_complete exam_sitting
    redirect_to exam_sitting_path exam_sitting
  end

  private

  def already_answered
    if question_response_administration.answered?
      redirect_to exams_path, notice: I18n.t(".question_responses.already_answered")
    end
  end

  def question_response_administration
    @question_response_administration ||=
      QuestionResponseAdministration.new(self, dao)
  end

  def dao
    @dao ||= Dao::QuestionResponse.new exam_sitting_id, question_id
  end

  def exam_sitting_id
    params[:exam_sitting_id]
  end

  def question_id
    params[:question_id]
  end

  def set_question_response
    @question_response = question_response_administration.find_question_response(params[:id])
  end
end
