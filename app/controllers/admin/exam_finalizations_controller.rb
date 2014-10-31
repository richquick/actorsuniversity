class Admin::ExamFinalizationsController < Admin::ApplicationController
  def create
    exam = ::Exam.find exam_id

    exam.finalize!
    redirect_to exam
  end

  private

  def exam_id
    params.require(:exam_finalization).permit(:exam_id)[:exam_id]
  end
end
