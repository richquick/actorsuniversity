module Dao
  class Lesson
    def create_lesson_with_saved_resource lesson_attributes, token
      create_lesson(lesson_attributes) do |l|
        l.resource_file = resource_file_from(token)
      end
    end

    def resource_file_from token
      ::ResourceFile.where(lesson_token: token).first
    end

    def update_lesson_including_tags user, id, attributes
      tags = attributes.delete :tags

      tag_lesson(user, tags, id).tap do |lesson|
        lesson.update_attributes attributes
        upload = resource_file_from(attributes[:token])
        lesson.resource_file = upload
      end
    end

    def tag_lesson(user, tags, id)
      Dao::Tag.new.tag_lesson(user, tags, id)
    end

    def find_lesson_including_resource id
      lesson = find_lesson(id)
      add_empty_resource_to_lesson lesson
    end

    def add_empty_resource_to_lesson lesson
      lesson.tap do |l|
        if l.resource_file.nil?
          token = generate_token
          l.build_resource_file lesson_token: token
          l.token = token
        end
      end
    end

    def new_lesson
      add_empty_resource_to_lesson ::Lesson.new
    end

    def create_lesson attributes
      ::Lesson.create attributes do |l|
        yield l if block_given?
      end
    end

    def find_lesson id
      ::Lesson.find id
    end

    def generate_token
      loop do
        random_token = SecureRandom.urlsafe_base64
        break random_token unless ::Lesson.where(token: random_token).exists?
      end
    end
  end
end
