require 'fast_spec_helper'
require './app/services/tagging'

describe Tagging do
  let(:user)      { double 'User' }

  let(:framework) do
    double 'framework', create_success: nil
  end
  subject(:tagging) { Tagging.new framework, dao }

  context "tagging a lesson" do
    let(:lesson){ double 'lesson', id: lesson_id }
    let(:lesson_id){ 1 }

    let(:tag_1) { double 'Tag', name: "cool" }
    let(:tag_2) { double 'Tag', name: "しぶい" }

    let(:dao)       { double 'Dao', tag_lesson: [tag_1, tag_2]  }
    let(:tags) { "cool, しぶい" }

    it "performs the tagging" do
      dao.should_receive(:tag_lesson).with(user, tags, lesson_id)

      tagging.tag(:lesson, user, tags, lesson_id)
    end

    it "calls the framework success callback" do
      framework.should_receive(:create_success).with([tag_1, tag_2])

      tagging.tag(:lesson, user, tags, lesson_id)
    end
  end

  context "tagging a course" do
    let(:course){ double 'course', id: course_id }
    let(:course_id){ 1 }

    let(:tag_1) { double 'Tag', name: "dull" }
    let(:tag_2) { double 'Tag', name: "ださい" }

    let(:dao)       { double 'Dao', tag_course: [tag_1, tag_2]  }
    let(:tags) { "dull, ださい" }

    it "performs the tagging" do
      dao.should_receive(:tag_course).with(user, tags, course_id)

      tagging.tag(:course, user, tags, course_id)
    end

    it "calls the framework success callback" do
      framework.should_receive(:create_success).with([tag_1, tag_2])

      tagging.tag(:course, user, tags, course_id)
    end
  end
end
