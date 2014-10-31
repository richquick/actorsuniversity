module SearchResult
  class CoursePresenter < Presenter
    def format_result r
      super.merge media_type: klass_name
    end

    def title_field
      :title
    end
  end
end
