Fabricator :user_phone_number do
  phone_number_type "mobile"
  number "0777 123456"
end

Fabricator :mobile_phone_number, from: :user_phone_number

Fabricator :office_phone_number, from: :user_phone_number do
  phone_number_type "office"
  number "0207 456 7891"
end

Fabricator :admin, from: :user do
  email 'admin@actorsuniversity.com'
  password 'hung3rg4m3s'

  after_create do |u|
    u.roles << Role.admin
  end
end

Fabricator :user do
  email 'user@actorsuniversity.com'
  password 'hung3rg4m3s'

  after_create do |u|
    u.user_phone_numbers << Fabricate(:user_phone_number)
    u.user_links << Fabricate(:user_link)
  end
end

Fabricator :user_link do
  link_type "linked_in"
  url "https://www.linkedin.com/pub/jack-silver/97/602/410"
end

Fabricator :twitter_link, from: :user_link do
  link_type "twitter"
  url "https://twitter.com/jacksilver"
end

Fabricator :lesson do
  title "Youtube video about cats"
  description "Learn all about cats - it's important"
  external_resource_url "http://youtube.com/something"
end

Fabricator :resource_file do
  resource_file {
    ActionDispatch::Http::UploadedFile.new(
      :tempfile => File.new(Rails.root.join("spec/fixtures/assets/example.png")),
      :filename => File.basename(File.new(Rails.root.join("spec/fixtures/assets/example.png")))
    )
  }
end

Fabricator :lesson_with_upload, from: :lesson do
  title "Youtube video about cats"
  description "Learn all about cats - it's important"
  resource_file Fabricate(:resource_file)
end


Fabricator :course do
  title "Intro to youtube videos about cats"
  description "Everything you need to know about cats falling over, and sitting in dogs' beds"
end

Fabricator :course_with_lesson, from: :course do
  after_create do |c|
    c.lessons << Fabricate(:lesson)
  end
end

Fabricator :group do
  name "Induction group"
  description "Everything you need to know about working here"
end
