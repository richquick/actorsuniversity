require 'ffaker'
require 'populator'

desc 'Load fake data for development/testing.'
task :faker => [
  'db:setup', 'devise:setup', 'fake:groups', 'fake:users',
  'fake:courses', 'fake:lessons', 'fake:exams', 'fake:questions'
]

namespace :fake do
  NUM_USERS = 50
  NUM_LESSONS = 10
  NUM_COURSES = 10

  def validate klass
    first = klass.first

    if first.valid?
     puts "first #{klass} is ok"
    else
      puts "#{klass} invalid"
      puts first.errors.full_messages
      exit(-1)
    end
  end

  def healthcare_paragraph
    Faker::HealthcareIpsum.paragraph(5)[0..254].html_safe
  end

  def healthcare_sentence
    Faker::HealthcareIpsum.sentence(1).html_safe
  end

  desc 'Create some fake users'
  task :users => :environment do
    User.populate NUM_USERS do |u|
      u.name = Faker::Name.name
      u.encrypted_password = 'password'
      u.email = Faker::Internet.email
      u.sign_in_count = 0
      #u.phone_number = Faker::PhoneNumber.short_phone_number
      u.bio = healthcare_paragraph
    end

    validate User

    user_counter  = User. count - 1
    user = User.find_by email: 'admin@actorsuniversity.com'
    user.groups = Group.all
    user.save!

    Allocation::UserToGroup.populate (NUM_USERS * 3 * rand).to_i do |a|
      a.user_id  = user_counter  = user_counter  - 1
    end

    user_counter  = User. count - 1
    group_counter = Group.count - 1

    Allocation::UserToGroup.populate (NUM_USERS * 3).to_i do |a|
      a.user_id  = user_counter  = user_counter  - 1
      a.group_id = group_counter = group_counter - 1
    end

    skills = Faker::Skill::TECH_SKILLS + Faker::Skill::SPECIALTY_START
    skills.each do |s|
      ActsAsTaggableOn::Tag.create! name: s
    end

    tag_ids = ActsAsTaggableOn::Tag.pluck :id
    user_ids = User.pluck :id

    ActsAsTaggableOn::Tagging.populate User.count do |t|
      t.taggable_type = 'User'
      t.taggable_id = user_ids.sample
      t.tag_id = tag_ids.sample
      t.context = "skills"
    end

    ActsAsTaggableOn::Tagging.populate User.count do |t|
      t.taggable_type = 'User'
      t.taggable_id = user_ids.sample
      t.tag_id = tag_ids.sample
      t.context = "interests"
    end
  end

  desc 'Create some fake groups'
  task :groups => :environment do
    Group.create! name: 'Sales', description: healthcare_paragraph
    Group.create! name: 'Marketing', description: healthcare_paragraph
    Group.create! name: 'Executive', description: healthcare_paragraph
    Group.create! name: 'Operations', description: healthcare_paragraph
    Group.create! name: 'Information Technology', description: healthcare_paragraph
    Group.create! name: 'Engineering', description: healthcare_paragraph

    validate Group

  end

  desc 'Create some fake courses'
  task :courses => :environment do
    Course.populate NUM_COURSES do |c|
      c.title = healthcare_sentence
      c.description = healthcare_paragraph
    end

    validate Course
    course_counter = Course.count - 1
    group_counter = Group.count - 1

    tag_ids = ActsAsTaggableOn::Tag.pluck :id
    course_ids = Course.pluck :id

    ActsAsTaggableOn::Tagging.populate Course.count do |t|
      t.taggable_type = 'Course'
      t.taggable_id = course_ids.sample
      t.tag_id = tag_ids.sample
    end

    Allocation::CourseToGroup.populate (NUM_COURSES * 3 * rand).to_i do |a|
      a.course_id = course_counter = course_counter - 1
      a.group_id  = group_counter  = group_counter - 1
    end
  end

  desc 'Create some fake lessons'
  task :lessons => :environment do
    Lesson.populate NUM_LESSONS do |l|
      l.title = healthcare_sentence
      l.description = healthcare_paragraph
      l.external_resource_url = Faker::Internet.http_url
    end

    validate Lesson
    lesson_counter = Lesson.count - 1
    course_counter = Course.count - 1

    Allocation::LessonToCourse.populate (NUM_LESSONS * 10 * rand).to_i do |a|
      a.lesson_id = lesson_counter = lesson_counter - 1
      a.course_id = course_counter = course_counter - 1
    end

    tag_ids = ActsAsTaggableOn::Tag.pluck :id
    lesson_ids = Lesson.pluck :id

    ActsAsTaggableOn::Tagging.populate Lesson.count do |t|
      t.taggable_type = 'Lesson'
      t.taggable_id = lesson_ids.sample
      t.tag_id = tag_ids.sample
    end
  end

  desc 'Create some fake exams'
  task :exams => :environment do
    Exam.populate NUM_COURSES do |l|
      l.title = healthcare_sentence
      l.description = healthcare_paragraph
    end

    validate Exam
    exam_counter   = Exam.count   - 1
    course_counter = Course.count - 1

    Allocation::CourseToExam.populate (NUM_COURSES * 10 * rand).to_i do |a|
      a.exam_id = exam_counter     = exam_counter - 1
      a.course_id = course_counter = course_counter - 1
    end
  end

  def answer
    Answer.new(text: healthcare_sentence[0..50], correct: [true, false].sample)
  end

  def answers q
    q.answers.count
  end

  def correct q
    q.answers.map(&:correct).count true
  end

  desc 'Create some fake questions'
  task :questions => :environment do
    NUM_QUESTIONS = 100
    exam_ids   = Exam.pluck(:id)[1..NUM_QUESTIONS]
    Question.populate NUM_QUESTIONS do |l|
      l.exam_id = exam_ids.sample
      l.tag_line = healthcare_paragraph
      question = Faker::Conference.name
      l.question_text = question + "?"
    end

    processed = 0

    Question.all.limit(NUM_QUESTIONS).each do |q|
      puts "adding answer to qu:#{q.id}, #{NUM_QUESTIONS - processed} left to go"
      until (answers(q) >= 2) && (correct(q) >= 1) do
        (1 + rand(5)).times { q.answers << answer }
      end

      q.save!
      processed += 1
    end

    validate Question
  end
end
