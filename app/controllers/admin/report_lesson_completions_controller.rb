class Admin::ReportLessonCompletionsController < Admin::ApplicationController
  respond_to :csv

  def show
    report = ReportLessonCompletion.new report_lesson_completion_params

    respond_to do |format|
      format.csv { render :csv => report.lesson_completions, filename: report.filename }
    end
  end

  private

  def report_lesson_completion_params
    params.require(:report_lesson_completion).permit(:start_date, :end_date)
  end
end



