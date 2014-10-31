module Dao
  class Group
    def create attributes
      ::Group.create attributes
    end

    def new
      ::Group.new
    end

    def all
      ::Group.all
    end

    def find id
      ::Group.find id
    end

    def update id, attributes
      find(id).tap do |g|
        g.update_attributes attributes
      end
    end

    def destroy id
      ::Group.destroy(id)
    end

    def add_user id, user
      group = find(id)
      group.users << user
    end
  end
end
