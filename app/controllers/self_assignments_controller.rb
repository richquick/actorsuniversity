class SelfAssignmentsController < ApplicationController
  def create
    service.assign assignment_attributes
  end

  def create_success assignment
    redirect_to assignment.send assign_to_type
  end

  def create_failure assignment
    @assignment = assignment

    render :new
  end

  def destroy
    service.unassign(assign_to_type, assign_to_id)

    render nothing: true
  end

  def assignment
    @assignment ||= service.new_assignment(assign_to_type, assign_to_id)
  end

  # POST sign_me_up_for/:assign_to_type
  # POST sign_me_up_for/lesson/1
  def form_path
    @form_path ||= create_assignment_path(assign_to_type)
  end

  def assign_to_type
    sanitize_assignment_type(params[:assign_to_type])
  end


  helper_method :assignment, :form_path

  private

  def assignment_attributes
     {
      :user => current_user.id,
      assign_to_type => assign_to_id
    }
  end

  def valid_params?
    return false if assign_to_type.nil?
    return false if assign_to_id.nil?
    true
  end

  def dao
    Dao::EducationAdministration.new
  end

  def service
    EducationAdministration.new(self, dao)
  end

  #used in the views so need to sanitize
  def sanitize_assignment_type t
    t if valid_assignment_types.include? t
  end

  def valid_assignment_types
    %w(lesson course exam group)
  end

  helper_method :assign_to_id, :assignee_id, :assign_to_type, :assignee_type

  def assign_to_id
    Integer params[:assign_to_id]
  end
end
