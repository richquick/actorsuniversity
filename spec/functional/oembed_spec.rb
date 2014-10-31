require 'spec_helper'

describe OembedsController, type: :controller do
  before do
    sign_in_with_double
  end

  it do
    VCR.use_cassette 'oembed' do
      get :show, url: 'http://www.youtube.com/watch?v=5Srrn5m-C9A', format: :json
    end

    JSON.parse(response.body).should == {
      "thumbnail_width"  => 480,
      "type"             => "video",
      "height"           => 344,
      "author_name"      => "mercedesbenz",
      "thumbnail_url"    => "http://i1.ytimg.com/vi/5Srrn5m-C9A/hqdefault.jpg",
      "html"             => "<iframe width=\"459\" height=\"344\" src=\"http://www.youtube.com/embed/5Srrn5m-C9A?feature=oembed\" frameborder=\"0\" allowfullscreen></iframe>",
      "title"            => "Mercedes-Benz TV-Spot \"Chicken\"",
      "author_url"       => "http://www.youtube.com/user/mercedesbenz",
      "provider_name"    => "YouTube",
      "width"            => 459,
      "version"          => "1.0",
      "thumbnail_height" => 360,
      "provider_url"     => "http://www.youtube.com/"
    }
  end
end
