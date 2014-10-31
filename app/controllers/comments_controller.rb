class CommentsController < ApplicationController
  def create
    @comment = Comment.create(comment_attributes.merge user_id: current_user.id)

    redirect_to @comment.commentable
  end

  private

  def comment_attributes
    params.require(:comment).permit(
      :role, :comment, :title,
      :commentable_id, :commentable_type
    )
  end
end
