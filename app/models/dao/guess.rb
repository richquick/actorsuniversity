module Dao
  class Guess
    def create attributes
      ::Guess.create attributes
    end

    def new
      ::Guess.new
    end

    def all
      ::Guess.all
    end

    def find id
      ::Guess.find id
    end

    def update id, attributes
      find(id).tap do |g|
        g.update_attributes attributes
      end
    end

    def destroy id
      ::Guess.destroy(id)
    end
  end
end
