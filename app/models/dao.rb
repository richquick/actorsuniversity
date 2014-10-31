# The way we're doing DAO here might seem a bit upside-down
# So the basic philosophy is something like this
#
# 1. Lean startup, e.g. build throwaway features, iterate, don't build more than needed
# 2. This leads to doing things like following Rails defaults, which are not great for OOP
#   * See avdi - 'Objects on Rails'/giles bowkett 'Rails as she is spoke' etc for more
# 3. Try to have decent OOP where possible
# 4. We are in a hybrid situation balancing point 1 and 3
#   * This means using AR, which means AR abstractions starting to pollute the
#   domain logic
#
# So to counter the negative effects of 4, whenever there's a bunch of e.g.
# more than User.find(params[:id]), code I've started to pull into it's own Dao object
#
# The upshot is we have AR still responsible for instantiating our objects and the like
# but we have a tidy place where we can hide away complex queries from the domain
#
# I suspect the right direction is to start instantiating objects in our domain, then
# calling the dao to persist them.
# I'll consider namespacing all our AR models with Persistence and see how that goes
module Dao
end
