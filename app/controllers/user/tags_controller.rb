class User::TagsController < ApplicationController
  def index
    @tags = current_user.owned_tags
  end

  def update
    current_user.tag(current_user,with: tag_list, on: taggable_type)

    redirect_to "/me/edit"
  end

  private

  def tag_list
    tag_params[:tag_list]
  end

  def taggable_type
    tag_params[:taggable_type]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params[:user].permit(:tag_list, :taggable_type)
  end
end
