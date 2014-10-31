module Dao
  class Search
    def self.prepopulate
      new.prepopulate
    end

    def users_by(*types)
      types.map do |type|
        relationships = ::User.tag_counts_on(type).limit(10)

        response = {}

        relationships.map do |r|
          response[r.name]  = ::User.tagged_with(r.name, :on => type.to_s, :any => true)
        end

        response
      end
    end

    def prepopulate
      results = {}

      results["Course"] = ::Course.all.limit 20
      results["Lesson"] = ::Lesson.all.where("archived = false or archived is null").limit 20
      results["User"] = prepopulate_users

      results
    end

    def prepopulate_users
      users = {}

      skills, interests = users_by :skills, :interests

      users["skills"]    = skills
      users["interests"] = interests
      extra_users = ::User.all.limit(100)
      users["users"] = extra_users
      users
    end
  end
end
