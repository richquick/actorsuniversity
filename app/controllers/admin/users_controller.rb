class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  decorates_assigned :user, :users

  def index
    @users = User.paginate(:page => params[:page]).includes(:roles, :groups, :allocation_user_to_groups).references(:groups)
  end

  def show
  end

  def new
    @user = User.new
    @user.user_roles.build
  end

  def edit
    @user.user_roles.build if @user.user_roles.none?
  end

  def create
    administrator.create(user_params)
  end

  def create_success user
    redirect_to [:admin, user], notice: 'User was successfully created.'
  end

  def create_failure user
    render action: 'new'
  end

  def update
    administrator.update params[:id], user_params
  end

  def update_success user
    redirect_to admin_users_path, notice: 'User was successfully updated.'
  end

  def update_failure user
    @user = user
    render action: 'edit'
  end

  def destroy
    @user.destroy

    redirect_to admin_users_url
  end

  private

  def administrator
    @administrator ||= UserAdministration.new self, Dao::User.new
  end

  def set_user
    @user = UserDecorator.new User.find(params[:id])
  end

  def user_params
    params[:user].permit(
      {:user_roles_attributes => ["_destroy", "id", "role_id"]},
      :avatar_image, :avatar_image_cache,
      :job_title, :bio,
      {:user_phone_numbers_attributes => ["id", "phone_number_type", "_destroy", "number"]},
      {:user_links_attributes => ["id", "link_type", "url", "_destroy"]},
      :taggable_type, :tag_list,
      :name, :password, :email)
  end
end
