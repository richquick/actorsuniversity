class Admin::ApplicationController < ApplicationController
  class Action < Admin::ApplicationController
    include FocusedController::Mixin
  end

  before_filter :authenticate_admin!

  def authenticate_admin!
    authenticate_user!

    return true if admin? || admin_using_rest_in_place? || allowed_to_change_role?

    redirect_to root_path, notice: "Unauthorized"
  end

  private

  def admin_using_rest_in_place?
    #TECHDEBT - need a better way of determining if we're editing using
    #rest-in-place, rather than just "Is this AJAX?"
    normally_admin? && request.xhr?
  end

  def allowed_to_change_role?
    normally_admin? && params[:controller] == "admin/role_usages"
  end
end
