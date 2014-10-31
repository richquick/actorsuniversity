class Admin::ExamsController < Admin::ApplicationController
  decorates_assigned :exam, with: ExamPresenter
  before_action :set_exam, only: [:show, :edit, :destroy]

  def index
    @exams = Exam.paginate(page: params[:page])
  end

  def show
  end

  def new
    @exam = Exam.new
  end

  def edit
  end

  def create
    administrator.create exam_params
  end

  def create_success exam
    redirect_to new_admin_exam_question_path(exam)
  end

  def create_failure exam
    @exam = exam
    render action: 'new'
  end

  def update
    administrator.update params[:id], exam_params
  end

  def update_success exam
    redirect_to new_admin_exam_question_path(exam)
  end

  def update_failure exam
    @exam = exam
    render action: 'edit'
  end

  def destroy
    @exam.destroy
    redirect_to admin_exams_path
  end

  private

  def set_exam
    @exam = Exam.find(params[:id])
  end

  def exam_params
    params.require(:exam).permit(
      :title,
      :description,
      :questions_attributes => [
        :id,
        :question_text,
        :tag_line,
        :_destroy,
        :answers_attributes => [
          :id,
          :_destroy,
          :text, :correct]
      ]
    )
  end

  def administrator
    @administrator ||= ExamAdministration.new self, Dao::Exam.new
  end
end
