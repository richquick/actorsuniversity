module SearchResult
  class LessonPresenter < Presenter
    def format_result lesson
      l  = LessonPresenterSelector.for lesson

      media_type = "#{l.media_type} lesson"

      {title: l.title, media_type: media_type, value: l.title, url: "\/#{klass_name}s\/#{l.id}"}
    end
  end
end
