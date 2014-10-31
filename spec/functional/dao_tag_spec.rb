require 'spec_helper'

describe Dao::Tag do
  let(:user) { Fabricate :user }

  describe "tag_lesson" do
    let(:dao) { Dao::Tag.new }
    let!(:lesson) { Fabricate :lesson }
    specify do
      dao.tag_lesson user, "some, tags go, here", lesson.id
      lesson.reload
      lesson.tags.count.should == 3
    end
  end

  describe "tag_course" do
    let(:dao) { Dao::Tag.new }
    let!(:course) { Fabricate :course }
    specify do
      dao.tag_course user, "some, tags go, here", course.id
      course.reload
      course.tags.count.should == 3
    end
  end
end
