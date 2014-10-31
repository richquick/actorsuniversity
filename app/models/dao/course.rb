module Dao
  class Course
    def suggested_courses_for user
      (::Course.all.limit(10) - user.courses)[0..4]
    end

    def update_course attributes
      id = attributes.delete :id

      ::Course.find(id).tap do |c|
        c.update_attributes attributes
      end
    end
  end
end
