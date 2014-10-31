class LinkLessonDecorator < LessonDecorator
  def url
    url_with_enforced_scheme
  end

  def formatted_url
    if external_resource_uri.present?
      url_with_enforced_scheme
    else
      ""
    end
  end

  private

  def url_with_enforced_scheme
    external_resource_uri.scheme.blank? ? "http://#{external_resource_uri}" : external_resource_uri
  end
end
