require 'spec_helper'

describe YoutubeLessonDecorator do
  let(:lesson) do
    Lesson.new external_resource_url: "http://www.youtube.com/watch?v=5Srrn5m-C9A"
  end

  let(:presenter) do
    YoutubeLessonDecorator.new lesson
  end

  specify do
    presenter.formatted_url.should ==
      "//www.youtube.com/embed/5Srrn5m-C9A"
  end
end
