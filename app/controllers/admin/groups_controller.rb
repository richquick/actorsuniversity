class Admin::GroupsController < Admin::ApplicationController
  def index
    @groups = administrator.all_groups
  end

  def new
    @group = administrator.new_group
  end

  def create
    administrator.create group_params
  end

  def create_success group
    redirect_to admin_groups_path
  end

  def create_failure group
    @group = group
    render :new
  end

  def edit
    @group = administrator.find_group params[:id]
  end

  def update
    administrator.update_group params[:id], group_params
  end

  def update_success group
    redirect_to admin_groups_path
  end

  def update_failure group
    @group = group
    render :edit
  end

  def destroy
    administrator.destroy_group params[:id]

    redirect_to admin_groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :description, :public)
  end

  def administrator
    @administrator ||= GroupAdministration.new self, Dao::Group.new
  end
end
