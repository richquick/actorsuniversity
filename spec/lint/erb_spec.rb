require 'spec_helper'

describe "Ruby syntax" do
  def valid_eruby_syntax?(erb)
    valid = begin
              ActionView::Template::Handlers::Erubis.new(erb).result
            rescue SyntaxError => e
              e
            rescue StandardError => e
              true
            end

    valid.should_not be_a SyntaxError
  end

  def self.load_files directory, pattern
    Dir.glob(File.join(Rails.root, directory) << pattern)
  end

  describe "Valid ERB" do
    views = load_files("app/views/", "**/**/*.html.erb")

    views.each do |c|
      specify "#{c} should have valid syntax" do
        code = File.read(c)
        valid_eruby_syntax?(code)
      end
    end
  end
end
