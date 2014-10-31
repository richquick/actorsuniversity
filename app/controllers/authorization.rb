class Authorization
  Unauthorized = Class.new StandardError

  include Virtus
  attribute :current_user
  attribute :session

  def spoof! role
    unauthorized! unless current_user.has_role? role

    session[:spoofed_role] = role
  end

  def unspoof!
    session[:spoofed_role] = nil
  end

  def admin?
    normally_admin? && (spoofed_role.blank? || spoofed_admin?)
  end

  def spoofed_admin?
    spoofed_role == "admin"
  end

  def spoofed_role
    session[:spoofed_role]
  end

  def normally_admin?
    current_user.try :admin?
  end

  def non_admin_user?
    current_user && !admin?
  end

  private

  def unauthorized!
    raise Unauthorized
  end
end
