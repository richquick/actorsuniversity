module ApplicationHelper
  def body_class
    classes = []
    classes << "admin" if admin?

    classes << "client_#{client_name} "
    classes << "logged_out " unless current_user

    "class='#{classes.join " "}'".html_safe
  end

  def format_time t
    t.strftime "%a, %e %b %Y"
  end

  def app_name
    case client_name
    when :client
      "Actors University"
    else
      "Actors University (#{client_name.to_s.humanize})"
    end
  end

  def editable?(object)
    can?(current_user, :edit, object)
  end

  def editable_item tag_type, object, field, input_type=nil
    value = object.send field
    if editable? object
      value = value.blank? ? "click to edit" : value

      field_type = input_type ? "data-formtype='#{input_type}'" : ''
      "<#{tag_type} #{field_type} class='rest-in-place' data-attribute='#{field}'>#{value}</#{tag_type}>".html_safe
    else
      "<#{tag_type}>#{value}</#{tag_type}>".html_safe
    end
  end

  def me? user
    (user == current_user)
  end

  def already_following? user
    #TECHDEBT - move into another object
    current_user.pursued_followings.
      find_by(pursued_id: user.id)
  end

  def format_tag_list tags
    Array(tags).map(&:name).join(",")
  end

  def format_taggable_type type
    type.present? ? "Add #{type}" :  t("Tag")
  end

  def remove_lesson_from_course_link lesson, course
    attributes = unassign_attributes lesson, course

    path = admin_unassign_from_path(*attributes, method: :delete)

    link_to t(".remove_from_course"), path,
      data: { confirm: 'Are you sure?' },
      :class => "condensed minus button"
  end

  def unassign_attributes a, b
    {assignee_type: a.class.name.downcase,
     assignee_id: a.id,
     assign_to_type: b.class.name.downcase,
     assign_to_id: b.id}.values
  end


end
