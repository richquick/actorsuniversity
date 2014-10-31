class UsersController < ApplicationController
  before_filter :user, only: [:edit, :update, :show]
  respond_to :html, :json

  def edit
  end

  def show
    user = if params[:id]
              User.find params[:id]
            else
              current_user
            end

    @user = decorate user

    #TECHDEBT need a service object
    @completed_lessons = @user.completed_lessons.map{|l| LessonPresenterSelector.for l }
    @follower_followings = @user.follower_followings
    @pursued_followings = @user.pursued_followings

    respond_with do |format|
      format.html { render :show }
      format.json { render json: @user }
    end
  end

  def update
    if user.set_profile_attributes! user_attributes
      redirect_to "/me"
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end

  private

  def decorate user
    UserDecorator.new user
  end

  def user
    @user ||= current_user
  end

  def user_attributes
    admin? ? admin_params : user_params
  end

  def user_params
    admin_params.dup.tap do |a|
      a.delete :user_roles_attributes
    end
  end

  def admin_params
    #TECHDEBT - security review
    params[:user].permit(
      :job_title,
      :name,
      :email,
      :bio,
      :avatar_image,
      :avatar_image_cache,
      :password,
      user_roles_attributes: [:id, :_destroy, :role_id],
      user_phone_numbers_attributes: [:id, :_destroy, :number, :phone_number_type],
      user_links_attributes:         [:id, :_destroy, :url, :link_type]
    )
  end

end
