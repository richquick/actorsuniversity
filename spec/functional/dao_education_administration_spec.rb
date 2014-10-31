require 'spec_helper'

describe Dao::EducationAdministration do
  let(:dao) do
    Dao::EducationAdministration.new
  end

  %w(user group course lesson).each do |a|
    let(a) { Fabricate a }
  end

  describe "#new_course_to_exam" do
    let(:exam) { Fabricate :exam }

    it do
      assignment = dao.new_course_to_exam nil, exam.id
      assignment.exam.should == exam
      assignment.course.should be_new_record
    end
  end


  describe "#new_user_to_group" do
    it do
      assignment = dao.new_user_to_group user.id
      assignment.user.should == user
      assignment.group.should be_new_record
    end
  end

  describe "#assign_user_to_group" do
    specify do
      dao.assign_user_to_group user.id, group.id
      user.groups.should include group
    end
  end

  describe "#assign_course_to_group" do
    specify do
      dao.assign_course_to_group course.id, group.id
      course.groups.should include group
    end
  end

  describe "#assign_lesson_to_course" do
    specify do
      course.lessons = []
      dao.assign_lesson_to_course lesson.id, course.id
      course.reload
      course.lessons.should include lesson
    end
  end

  describe "#assign_user_to_course" do
    specify do
      dao.assign_user_to_course user.id, course.id
      course.users.should == [user]
      user.courses.should == [course]
    end
  end

  describe "#assign_lesson_to_user" do
    specify do
      dao.assign_lesson_to_user lesson.id, user.id

      lesson.users.should include user

      user.lessons.should include lesson
    end
  end

  describe "#assign_lesson_to_group" do
    specify do
      dao.assign_lesson_to_group lesson.id, group.id
      group.lessons.should include lesson
    end
  end
end
