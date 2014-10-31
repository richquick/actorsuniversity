class ImageLessonDecorator < LessonDecorator
  def filename
    resource_file.try(:resource_file).to_s
  end
end
