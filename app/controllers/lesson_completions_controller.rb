class LessonCompletionsController < ApplicationController
  def create
    LessonCompletion.create! lesson_id: params[:lesson_id], user_id: current_user.id

    redirect_to lesson_path params[:lesson_id]
  end
end
