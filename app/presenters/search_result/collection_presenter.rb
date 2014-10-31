module SearchResult
  class CollectionPresenter
    def self.format results
      new.format results
    end

    def format(results)
      results = results.dup
      formatted = present_users results.delete "User"

      results.each do |klass_name, r|
        klass = "::SearchResult::#{klass_name}Presenter".constantize

        formatted << klass.format_results(r)
      end

      formatted
    end

    private

    def present_users results
      presenter = UserSkillPresenter.new(results["skills"], "Users")

      [presenter.format]
    end
  end
end
