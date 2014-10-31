class Admin::CoursesController < Admin::ApplicationController
  before_action :set_course, only: [:show, :edit, :destroy]
  before_action :decorate_course, only: [:show, :edit]

  # GET /admin/courses
  # GET /admin/courses.json
  def index
    courses = Course.paginate(page: params[:page]).includes :allocation_course_to_groups
    @courses =  CoursesDecorator.new(courses)
  end

  # GET /admin/courses/new
  def new
    @course = Course.new
  end

  # GET /admin/courses/1/edit
  def edit
    allocations = @course.allocation_lesson_to_courses
    count = 3 - allocations.count

    count.times do
      allocations.build
    end
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to admin_courses_path, notice: 'Course was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    course_admin = CourseAdministration.new self, Dao::Course.new

    course_admin.update(course_params.merge id: params[:id])
  end

  def update_success course
    redirect_to admin_courses_path, notice: 'Course was successfully updated.'
  end

  def update_failure course
    render action: 'edit'
  end

  def destroy
    @course.destroy

    redirect_to admin_courses_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  def decorate_course
    @course = decorate @course
  end

  def decorate course
    CourseDecorator.new course
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_params
    params.require(:course).permit(:title,
                                   :image,
                                   :tag_list,
                                   {:course_lessons_attributes => [:lesson_id]},
                                   :description)
  end
end
