class UserDecorator < Draper::Decorator
  delegate_all

  def profile_image_url size=:medium
    filename = size == :full ? 'head_large' : 'head'

    avatar_image.url(:web, size) || h.asset_url("_framework/chassis/placeholders/#{filename}.png")
  end

  decorates User
end
