class Admin::DashboardsController < Admin::ApplicationController
  before_filter :set_funnel_graph_data, :set_piechart_data

  def show
    @dashboard = Admin::Dashboard.new
  end

  private

  def set_piechart_data
    gon.piechart_data =  [
      ['Completed lessons', users_completed],
      ['Logged in',         users_logged_in - users_completed],
      ['Not logged in',     users_not_logged_in],
    ]
  end

  def users_logged_in
    chart.users_logged_in(*time_range).count
  end

  def users_completed
    chart.users_completed(*time_range).count
  end

  def users_not_logged_in
    chart.users_not_logged_in(*time_range).count
  end

  def lessons_completed
    @lessons_completed ||= chart.lessons_completed(*time_range).count
  end

  def time_range
    [Time.now - 1.month, Time.now]
  end

  def chart
    @chart ||= Chart.new
  end

  def set_funnel_graph_data
    gon.funnel_graph = chart.lessons_completed

    if chart.lesson_creations_by_date.any?
      gon.lesson_creation = chart.lesson_creations_by_date
      gon.lesson_creation_date_start = chart.first_lesson_completion_date

      gon.lesson_completion = chart.lesson_completions_by_date
      gon.lesson_completion_date_start = chart.first_lesson_creation_date
    end
  end
end
