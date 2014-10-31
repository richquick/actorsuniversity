require 'spec_helper'

describe Reminder do
  let(:reminder) { Reminder.new }

  before do
    group  = Fabricate :group

    group.courses = 3.times.map{ Fabricate :course }

    allocations = Allocation::CourseToGroup.all
    #2 due
    allocations[0].complete_by_date= Time.now + 2.days
    allocations[1].complete_by_date= Time.now - 2.days

    #1 not due
    allocations[2].complete_by_date= Time.now + 1.year

    allocations.each &:save

    4.times do
      Fabricate :user do |u|
        u.email { sequence(:email) { |i| "user#{i}@example.com" } }
      end
    end


    group.users = User.all
  end

  specify do
    reminder.send_all 'localhost'
    ActionMailer::Base.deliveries.count.should == 4
  end
end
