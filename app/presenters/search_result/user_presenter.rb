module SearchResult
  class UserPresenter < Presenter
    attr_reader :category

    def initialize results, category
      @search_results, @category = results, category
    end
  end
end
