class ServiceForUser
  include Hexagonal

  def initialize framework, dao, user
    super framework, dao
    @user = user
  end
end
