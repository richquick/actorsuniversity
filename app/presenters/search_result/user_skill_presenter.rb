module SearchResult
  class UserSkillPresenter < UserPresenter
    def format_results
      @search_results.map do |skill, users|
        users.map do |user|
          format_result(skill, user)
        end
      end.flatten
    end

    def klass_name
      "user"
    end

    def format_result skill, user
      {title: user.name,
       value: skill,
       media_type: klass_name.capitalize,
       url: "\/#{klass_name}s\/#{user.id}"}
    end

    def template
      '<a class="{{media_type}}" href="{{url}}">{{title}} - ({{value}})</a>'
    end
  end
end
