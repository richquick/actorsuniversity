class LessonPresenterSelector < Draper::Decorator
  delegate_all

  def self.for(lesson)
    new(lesson).presenter
  end

  def presenter
    presenter_klass.new object
  end

  def presenter_klass
    "#{media_type}LessonDecorator".classify.constantize
  end

  def media_type
    return :youtube if youtube?
    return :video if swf?

    if object.filename
      type = FileExtension.type_from_extension object.extension

      return :document if type.to_s =~ /office/ || type == :pdf

      return type if type
    end

    :link
  end

  def swf?
    external_resource_url =~ /\.swf\z/
  end

  def external_resource_uri
    if external_resource_url =~ %r{\Ahttp://|\Ahttps://}
      URI.parse(external_resource_url)
    else
      URI.parse("http://#{external_resource_url}")
    end
  end

  def youtube?
    if external_resource?
      %w(youtu.be youtube.com www.youtube.com).include? host
    end
  end

  def external_resource?
    external_resource_url.present?
  end

  def host
    external_resource_uri.host
  end
end
