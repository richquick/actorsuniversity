class Admin::QuestionsController < Admin::ApplicationController
  before_action :set_exam

  def new
    @question = @exam.questions.build
    2.times { @question.answers.build }
  end

  def edit
    @question = @exam.questions.find params[:id]
  end

  def create
    administrator.add_question @exam.id, question_params
  end

  def create_success question
    if @add_another
      redirect_to new_admin_exam_question_path(@exam)
    else
      redirect_to new_admin_exam_question_path(@exam)
    end
  end

  def create_failure question
    @question = question
    render action: 'new'
  end

  def update
    administrator.update_question params[:id], question_params
  end

  def update_success question
    redirect_to new_admin_exam_question_path(@exam)
  end

  def update_failure question
    @question = question
    render action: 'edit'
  end

  def destroy
    question = @exam.questions.find params[:id]
    question.destroy
    redirect_to new_admin_exam_question_path(@exam)
  end

  private

  def set_exam
    @exam = Exam.find(params[:exam_id])
  end

  def question_params
    params.require(:question).permit(
      :question_text,
      :tag_line,
      :_destroy,
      :answers_attributes => [
        :id,   :_destroy,
        :text, :correct]
    )
  end

  def administrator
    @administrator ||= ExamAdministration.new self, Dao::Exam.new
  end
end
