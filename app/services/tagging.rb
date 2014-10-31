class Tagging
  include Hexagonal

  def tag type, user, tags, id
    tags = dao.send(:"tag_#{type}", user, tags, id)

    framework.create_success tags
  end
end
