module Navigation
  extend ActiveSupport::Concern

  included do
    before_filter :prepopulate_search_js

    helper_method :studiable_items
  end

  def studiable_items
    without_noisy_queries do
      @studiable_items ||=
        {total: (courses_count + lessons_count), courses: courses_count, lessons: lessons_count}
    end
  end

  def courses_count
    @courses_count ||= Course.not_completed_yet(current_user).size
  end

  def lessons_count
    @lessons_count ||= lessons_to_do.count
  end

  def lessons_to_do
    @lessons_to_do ||= user_dao.lessons_to_do current_user
  end

  def user_dao
    @user_dao ||= Dao::User.new
  end

  def prepopulate_search_js
    return if request.xhr?

    without_noisy_queries do
      results = Dao::Search.prepopulate

      gon.search_prepopulated_data = SearchResult::CollectionPresenter.format(results)

    end
  end
end
