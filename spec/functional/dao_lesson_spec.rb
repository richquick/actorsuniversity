require 'spec_helper'

describe Dao::Lesson do

  let(:user) { Fabricate :user }

  describe "#update_lesson_including_tags" do 
    let(:attributes) do
      { title: "New lesson title", description: "New lesson description", 
        tags: "here's, some, different spaced apart, tags" } 
    end

    let(:dao) { Dao::Lesson.new }
    let!(:lesson) { Fabricate :lesson }
    specify do
      dao.update_lesson_including_tags user, lesson.id, attributes
      lesson.reload
      lesson.tags.count.should == 4
    end
  end
end
