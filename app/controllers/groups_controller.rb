class GroupsController < ApplicationController
  helper_method :enroled?

  def index
    @groups = current_user.groups
  end

  def show
    @group = Group.find(params[:id])
  end

  private

  def enroled? group
    current_user.groups.include? group
  end
end
