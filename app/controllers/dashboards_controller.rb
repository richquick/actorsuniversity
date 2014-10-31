class DashboardsController < ApplicationController
  before_filter :redirect_if_admin

  def show
    @dashboard = Dashboard.new current_user
  end

  private
  def redirect_if_admin
    redirect_to "/admin/dashboard" if admin?
  end
end
