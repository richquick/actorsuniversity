class EducationAdministration
  include Hexagonal

  delegate :new_user_to_group, :new_user_to_course,
    :new_course_to_group,
    to: :dao

  def new_assignment assignee_type, assignee_id, to_type, to_id
    template = "new_:a_to_:b"

    try_method_and_its_inverse(template, assignee_type, to_type, assignee_id, to_id)
  end

  def unassign a, b, a_id, b_id
    template = "unassign_:a_from_:b"
    try_method_and_its_inverse template, a, b, a_id, b_id
  end

  def assign attributes
    complete_by_date = attributes.delete(:complete_by_date)
    complete_within = attributes.delete(:complete_within)

    (from_assoc, from_id), (to_assoc, to_id) = check_args(attributes).to_a[0..1]
    meth = "assign_#{from_assoc}_to_#{to_assoc}"
    template = "assign_:a_to_:b"

    model = try_method_and_its_inverse(template, from_assoc, to_assoc, from_id, to_id)

    if complete_by_date.present?
      model.update_attribute :complete_by_date, complete_by_date
    end

    if complete_within.present?
      model.update_attribute :complete_within, complete_within
    end

    meth = model.valid? ? :create_success : :create_failure
    framework.send(meth, model)
  end

  private

  #tries e.g. assign_user_to_course and assign_course_to_user
  def try_method_and_its_inverse template, a, b, a_id, b_id
    meth = template.gsub(":a", a.to_s).gsub(":b", b.to_s)

    if dao.respond_to? meth
      dao.send(meth, a_id, b_id)
    else
      meth = template.
        gsub(":a", b.to_s).
        gsub(":b", a.to_s)
      dao.send(meth, b_id, a_id)
    end
  end

  #example attributes: {course: 1, group: 2}
  def check_args attributes
    error if attributes.length != 2

    attributes.each do |attr|
      error unless valid_attr_pair?(*attr)
    end

    attributes
  end

  def valid_attr_pair? type, id
    valid_fields.include?(type.to_s) && id.is_a?(Numeric)
  end

  def valid? from, to
    valid_fields.include?(from.to_s) &&
      valid_fields.include?(to.to_s)
  end

  def error
    raise ArgumentError
  end

  def valid_fields
    %w(exam course lesson user group)
  end
end
