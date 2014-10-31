class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include WithoutNoisyQueries
  include Navigation
  include Auth


  before_filter :js_set_user_type
  helper_method :current_action

  def current_action
    action = params[:action]

    {
      "index"    => "index",
      "new"     => "new",
      "create"  => "new",
      "update"  => "edit",
      "edit"    => "edit",
      "show"    => "show",
      "destroy" => "destroy"
    }[action]
  end

  def js_set_user_type
    gon.user_type = admin? ? "admin" : "user"
  end
end
