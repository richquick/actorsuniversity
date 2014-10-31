require 'spec_helper'

describe Lesson do
  [nil, "", "google . com", "123", "http", "blah", "#asdfasf"].each do |u|
    specify "#{u} is not valid" do
      link = Lesson.new external_resource_url: u
      link.should_not be_valid
      link.should have(1).errors_on(:external_resource_url)
    end
  end

  [
    "http://youtube.com", "youtube.com", "youtube.com/some/resource",
    "https://username:password@domain.com:8080/resource?query=sadaf&something=asdf"
  ].each do |u|
    specify "#{u} is valid" do
      link = Lesson.new external_resource_url: u
      link.should have(0).errors_on(:external_resource_url)
    end
  end

  let(:lesson) { Fabricate :lesson }

  describe ".archive!" do
    specify do
      Lesson.archive!(lesson.id)

      lesson.reload
      lesson.should be_archived
    end
  end

  describe "#pseudo_course" do
    specify do
      lesson.courses.should be_empty #make another fabricator if not

      lesson.pseudo_course.should be_a Course

      #default scope ignores pseudo_course
      lesson.courses.count.should == 0

      Course.pseudo.count.should == 1
    end
  end
end


