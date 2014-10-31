class Admin::LessonsController < Admin::ApplicationController
  decorates_assigned :lessons, with: LessonsDecorator
  respond_to :json, :html

  def index
    lessons = Lesson.paginate(:page => params[:page]).order(:created_at => :desc)
    @lessons = LessonsDecorator.decorate(lessons)
  end

  def new
    @lesson = lesson_administrator.new_lesson()
  end

  def edit
    @lesson = LessonDecorator.decorate lesson_administrator.edit(params[:id])
  end

  def show
    lesson = lesson_administrator.edit(params[:id])

    respond_to do |f|
      f.json { render json: lesson }
    end
  end

  def update
    lesson_administrator.update current_user, params[:id], lesson_params
  end

  # ..._success and ..._failure = Hexagonal pattern
  def update_success lesson
    respond_to do |f|
      f.html { redirect_to admin_lessons_path, notice: 'Lesson was successfully updated.' }
      f.json { respond_with lesson }
    end
  end

  # ..._success and ..._failure = Hexagonal pattern
  def update_failure lesson
    @lesson = lesson
    render action: 'edit'
  end

  def create
    lesson_administrator.create lesson_params, token
  end

  # ..._success and ..._failure = Hexagonal pattern
  def create_success lesson
    redirect_to admin_lessons_path
  end

  # ..._success and ..._failure = Hexagonal pattern
  def create_failure lesson
    @lesson = lesson
    render action: 'new'
  end


  private

  def lesson_administrator
    @lesson_administrator ||= LessonAdministration.new(self, dao)
  end

  def dao
    @dao ||= Dao::Lesson.new
  end

  def present l
    LessonPresenterSelector.for l
  end

  def lesson_params
    params[:lesson].permit(
      :external_resource_url,
      :resource_file,
      :token,
      :title,
      :description,
      :tag_list
    )
  end

  def token
    lesson_params[:token]
  end
end

