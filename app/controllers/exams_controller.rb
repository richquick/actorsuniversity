class ExamsController < ApplicationController
  decorates_assigned :exam, :exams, with: ExamPresenter

  def index
    @exams = current_user.exams
  end

  def show
    @exam = if normally_admin?
      Exam.find params[:id]
    else
      current_user.exams.detect{|e| e.id == params[:id].to_i}
    end

    if @exam.questions.none?
      redirect_to exams_path, notice: "Sorry this exam hasn't had any questions set yet"
    end
  end
end
