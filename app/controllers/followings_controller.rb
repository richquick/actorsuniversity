class FollowingsController < ApplicationController
  before_action :set_following, only: [:show, :edit, :update, :destroy]

  def create
    @following = Following.new(following_params.merge(follower_id: current_user.id))

    if @following.save
      render_success
    else
      render_failure
    end
  end

  def destroy
    @following.destroy
    respond_to do |format|
      format.html { redirect_to @following.follower }
      format.json { head :no_content }
    end
  end

  private

  def render_success
    respond_to do |format|
      pursued = @following.pursued
      format.html { redirect_to @following.pursued, notice: "You are now following #{pursued.name}" }
      format.json { render status: :created }
    end
  end

  def render_failure
    respond_to do |format|
      format.html { render status: :unprocessable_entity }
      format.json { render json: @following.errors, status: :unprocessable_entity }
    end
  end

  def set_following
    @following = Following.find(params[:id])
  end

  def following_params
    params.require(:following).permit(:pursued_id)
  end
end
