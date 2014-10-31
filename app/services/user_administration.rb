
class UserAdministration
  include Hexagonal

  def create attributes
    @user = dao.create attributes

    if @user.valid?
      framework.create_success @user
    else
      framework.create_failure @user
    end
  end

  def update id, attributes
    attributes.delete(:password) if attributes['password'].blank?

    @user = dao.update(id, attributes)

    if @user.valid?
      framework.update_success @user
    else
      framework.update_failure @user
    end
  end
end
