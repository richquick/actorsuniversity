# TECHDEBT - this whole controller was built to handle all the various
# different assignments of e.g. course to user, user to group, lesson to
# course, course to group.  As a result, it's almost certainly fewer lines of
# code, but probably overly complex.  And definitely now breaking SRP
#
# In adding in slight differences (e.g. complete_by_date to course_to_group
# assignments) it seems this was the wrong abstraction to introduce. Or at
# least it's wrong at present.  It may make more sense to separate into
# different controllers and overall having slightly more code
class Admin::EducationAssignmentsController < Admin::ApplicationController
  layout :layout_by_resource

  #get "assign/:assignee_type/:assignee_id/to/:assign_to_type"
  def new
    assignment if valid_params?
  end

  def create
    attributes = {assignee_type => assignee_id, assign_to_type => assign_to_id}.merge extra_attributes

    administrator.assign attributes
  end

  def create_success assignment
    redirect_to [:admin, assignee_type.pluralize], :notice => "#{assignee_type} was assigned to #{assign_to_type}"
  end

  def create_failure assignment
    @assignment = assignment

    render :new
  end

  def destroy
    administrator.unassign(assignee_type, unassign_from_type, assignee_id, unassign_from_id)

    path = send("#{assignee_type}_path", assignee_id)
    redirect_to path
  end

  def assign_to
    @assign_to ||= EducationAssignmentPresenter.new(assignment, assign_to_type, assignee_type)
  end

  def assignment
    @assignment ||= administrator.new_assignment(assignee_type, assignee_id, assign_to_type, assign_to_id)
  end

  # POST assign/:assignee_type/:assignee_id/to/:assign_to_type
  # POST assign/course/1/to/exam
  def form_path
    @form_path ||= admin_create_assignment_path(
      assignee_type, assignee_id, assign_to_type)
  end

  def assignee_type
    sanitize_assignment_type params[:assignee_type]
  end

  def assign_to_type
    sanitize_assignment_type(params[:assign_to_type])
  end

  def unassign_from_type
    sanitize_assignment_type(params[:unassign_from_type])
  end

  helper_method :assign_to, :assignment, :form_path

  private


  def layout_by_resource
    'no_navigation'
  end

  def valid_params?
    return false if assignee_type.nil? || assign_to_type.nil?
    return false if assign_to_id.nil? && assignee_id.nil?
    true
  end

  def extra_attributes
    {
      complete_by_date: params[:education_assignment][:complete_by_date],
      complete_within: params[:education_assignment][:complete_within]
    }
  rescue NoMethodError
    {}
  end

  def dao
    Dao::EducationAdministration.new
  end

  def administrator
    EducationAdministration.new(self, dao)
  end

  #used in the views so need to sanitize
  def sanitize_assignment_type t
    t if valid_assignment_types.include? t
  end

  def valid_assignment_types
    %w(lesson course exam group user)
  end

  helper_method :assign_to_id, :assignee_id, :assign_to_type, :assignee_type

  def assign_to_id
    int_param :assign_to_id, assign_to_type
  end

  def assignee_id
    int_param :assignee_id, assignee_type
  end

  def unassign_from_id
    Integer params[:unassign_from_id]
  end

  # This method probably exists for the wrong reason.
  # E.g. handle params coming in in the URL or in the body of
  # the POST request in a flexible fashion.
  def int_param key, fallback_key
    Integer params[key]
  rescue ArgumentError, TypeError
    field = "#{fallback_key}_id"

    begin
      Integer params[:education_assignment][field] 
    rescue NoMethodError
      nil
    end
  end


end
