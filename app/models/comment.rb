class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  default_scope -> { order('created_at ASC') }

  delegate :name, to: :user, prefix: true

  def user_thumbnail
    user.avatar_image_url(:web, :thumb)
  end

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

end
