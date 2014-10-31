class LessonDecorator < Draper::Decorator
  delegate_all

  def full
    resource_file.resource_file.url :full
  rescue NoMethodError
    nil
  end

  def preview
    resource_file.resource_file.url :preview
  rescue NoMethodError
    nil
  end

  def thumbnail
    resource_file.resource_file.url :thumb
  rescue NoMethodError
    nil
  end

  def media_type
    self.class.name.match(/(.*)LessonDecorator/)[1].underscore
  end

  def file_extension
    lesson.extension
  rescue NoMethodError
    ''
  end

  def external_resource_uri
    URI.parse(external_resource_url)
  end
end

