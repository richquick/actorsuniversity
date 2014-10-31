class Admin::LessonArchivementsController < Admin::ApplicationController
  def update
    Lesson.archive!(params[:id])

    redirect_to admin_lessons_path
  end

  def destroy
    Lesson.unarchive!(params[:id])

    redirect_to admin_lessons_path
  end
end
