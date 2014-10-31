module SearchResult
  class Presenter
    def self.format_results results
      new(results).format
    end

    def initialize results
      @search_results = results
    end

    def klass_name
      self.class.name.gsub(/SearchResult::|Presenter/,"").downcase
    end

    def category
      klass_name.capitalize
    end

    def media_type
      klass_name.capitalize
    end

    def format
      {
        name: '',
        local: format_results,
        header: "<h3>#{category}</h3>",
        template: template
      }
    end

    private

    def format_results
      @search_results.map{|r| format_result(r)}
    end

    def template
      '<a class="{{media_type}}" href="{{url}}">{{title}}</a>'
    end

    def format_result r
      {title: r.send(title_field),
       media_type: media_type,
       value: r.send(title_field),
       url: "\/#{klass_name}s\/#{r.id}"}
    end

    def title_field
      :name
    end
  end
end
