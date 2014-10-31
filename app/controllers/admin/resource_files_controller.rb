class Admin::ResourceFilesController < Admin::ApplicationController
  skip_before_filter :prepopulate_search_js, :set_redirect_location_for_admin, :js_set_user_type, except: [:edit, :update]

  def show
    @resource_file = lesson.resource_file || new_resource_file
  end

  def create
    @resource_file = ResourceFile.new(resource_file_params)

    if @resource_file.save
      update_success
    else
      update_failure
    end
  end

  def update
    @resource_file = ResourceFile.find params[:id]

    if @resource_file.update(resource_file_params)
      update_success
    else
      update_failure
    end
  end

  # DELETE /admin/resource_files/1
  # DELETE /admin/resource_files/1.json
  def destroy
    #only occurs from on the new lesson page, hence using the token which
    #links to the Lesson
    @resource_file = ResourceFile.find_by lesson_token: params[:id]

    @resource_file.destroy
    respond_to do |format|
      format.html { redirect_to new_admin_lesson_path, notice: "Resource file deleted" }
      format.json { head :no_content }
    end
  end

  def edit
    @resource_file = ResourceFile.find params[:id]
  end

  private

  def update_success
    respond_to do |format|
      format.html { redirect_to admin_lessons_path , notice: 'Resource file was successfully saved.' }
      format.json { render action: 'show'  }
    end
  end

  def update_failure
    respond_to do |format|
      format.html { render action: 'edit' }
      format.json { render json: {files: [error: @resource_file.errors[:resource_file]]}, status: :unprocessable_entity }
    end
  end

  def new_resource_file
    ResourceFile.new lesson_token: lesson_token
  end


  def lesson
    @lesson ||= Lesson.find_or_initialize_by(token: lesson_token)
  end

  def lesson_token
    params[:lesson_token] || resource_file_params[:lesson_token]
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def resource_file_params
    params[:resource_file].permit(:lesson_id, :lesson_token, :resource_file )
  end
end
