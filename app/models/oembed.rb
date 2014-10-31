class Oembed
  def self.for resource_url
    new.for(resource_url)
  end

  def for resource_url
    response = get(resource_url)

    if response.success?
      response.body
    else
      {}
    end
  end

  def get(resource_url)
    uri = URI.parse(resource_url)

    scheme, host, path = api_url_from uri.host
    connection = conn(scheme, host)
    connection.get path, url: resource_url, format: :json
  end

  def api_url_from host
    case host
    when 'www.youtube.com', 'youtube.com', 'youtu.be'
      ["http", "www.youtube.com", "/oembed"]
    when 'www.vimeo.com', 'vimeo.com'
      ["http", "vimeo.com", "/api/oembed.json"]
    when 'www.slideshare.net', 'slideshare.net'
      ["http", "www.slideshare.net", "/api/oembed/2"]
    end
  end

  def conn(scheme, host)
    url = "#{scheme}://#{host}"
    Faraday.new(:url => url) do |f|
      f.request  :url_encoded
      f.response :logger unless Rails.env.test?
      f.response :json, :content_type => /\bjson$/
      f.adapter  Faraday.default_adapter
    end
  end
end

