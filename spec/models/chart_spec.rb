require 'spec_helper'

describe Chart do
  let(:chart) { Chart.new }

  def time
    Time.parse("2013-08-08T07:00")
  end

  context "lesson_completions" do
    let!(:lesson) { Fabricate :lesson }
    let!(:lesson_2) { Fabricate :lesson }

    before do
      20.times do
        Fabricate :user do |u|
          u.email { sequence(:email) { |i| "user#{i}@example.com" } }
        end
      end

      user_ids = User.pluck :id

      #20 users total, 
      #user0-user4 1 lesson each,
      #user5 2 lessons
      {-2.days =>   [0,1],
       -1.day =>    [2,3],
       -1.minute => [4,5,5]
      }.each do |offset, users|
        Timecop.freeze time + offset do
          users.each do |u|
            LessonCompletion.create user_id: user_ids[u], lesson_id: lesson.id
          end
        end
      end
    end

    specify "#lessons_completed" do
      chart.lessons_completed(time - 5.minutes, time + 5.minutes).size.should == 1
      #20 users total, 
      #user0-user4 1 lesson each,
      #user5 2 lessons
      chart.lessons_completed[0].should == ["14 users =", 0]
      chart.lessons_completed[1].should == ["5 users =", 1]
      chart.lessons_completed[2].should == ["1 user =", 2]
    end

    specify "#lesson_completions_by_date" do
      t = time.beginning_of_day
      t1, t2, t3 = [t - 2.days, t -1.day, t]

      chart.lesson_completions_by_date.should == [
        [[t1.year, (t1.month - 1), t1.day], 2], #-2.days =>   [0,1], 2 users
        [[t2.year, (t2.month - 1), t2.day], 2], #-1.day =>    [2,3], 2 users
        [[t3.year, (t3.month - 1), t3.day], 3]  #-1.minute => [4,5,5] 3 users
      ]
    end
  end

  describe "#lesson_creations_by_date" do
    before do
      {-2.days   => 1,
       -1.day    => 2,
       -1.minute => 3}.each do |t, count|
         Timecop.freeze(time + t) do
           count.times { Lesson.new.save validate: false }
         end
       end
    end

    specify do
      Timecop.freeze time do
        t = time.beginning_of_day
        t1, t2, t3 = [t - 2.days, t -1.day, t]

        #http://www.highcharts.com/demo/spline-irregular-time
        #in js months count from zero?!
        # Date.UTC(1970,  0, 1) = 1st Jan 1970
        chart.lesson_creations_by_date.should == [

          # time = 2013 08 08
          [[2013, 7, 6], 1],
          [[2013, 7, 7], 2],
          [[2013, 7, 8], 3]
        ]
      end
    end
  end
end
