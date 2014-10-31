class YoutubeLessonDecorator < LessonDecorator
  def formatted_url
    "//www.youtube.com/embed/#{youtube_video_id}"
  end

  def youtube_video_id
    youtube_as_param || external_resource_uri.path
  end

  def youtube_as_param
    video_param = external_resource_uri.query.
      split("&").
      find{|q|q.split("=").first=="v"}

    video_param.split("=").last
  rescue StandardError
    nil
  end
end
