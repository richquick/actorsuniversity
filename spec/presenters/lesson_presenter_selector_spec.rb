require 'spec_helper'

describe LessonPresenterSelector do
  let(:lesson) do
    double external_resource_url: external_resource_url, filename: nil
  end

  let(:selector) { LessonPresenterSelector.new lesson }
  subject { selector.presenter }

  context "youtube" do
    [
      "http://www.youtube.com/watch?v=5Srrn5m-C9A",
      "www.youtube.com/watch?v=5Srrn5m-C9A",
      "youtube.com/watch?v=5Srrn5m-C9A",
    ].each do |url|
      let(:external_resource_url) { url }

      it do
        selector.presenter.should be_a YoutubeLessonDecorator
      end
    end
  end

  context "image" do
    let(:lesson) do
      double external_resource_url: nil, filename: "egg.jpg", extension: "jpg"
    end

    it { should be_a ImageLessonDecorator }
  end

  context "link" do
    let(:lesson) do
      double external_resource_url: "google.com", filename: nil
    end

    it { should be_a LinkLessonDecorator }
  end
end
