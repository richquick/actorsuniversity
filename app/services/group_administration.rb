class GroupAdministration
  include Hexagonal

  def create group_attributes
    group = dao.create group_attributes

    meth = group.valid? ? :create_success : :create_failure
    framework.send meth, group
  end

  def new_group
    dao.new
  end

  def find_group id
    dao.find id
  end

  def all_groups
    dao.all
  end

  def update_group id, attributes
    group = dao.update id, attributes

    meth = group.valid? ? :update_success : :update_failure

    framework.send meth, group
  end

  def destroy_group id
    dao.destroy id
  end
end
