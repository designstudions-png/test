class CommentsController < ApplicationController
  before_action :require_login

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: "Comment was successfully created."
    else
      redirect_to @post, alert: "Error creating comment."
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    if @comment.user == current_user || admin?
      @comment.destroy
      redirect_to @post, notice: "Comment was successfully deleted.", status: :see_other
    else
      redirect_to @post, alert: "You are not authorized to delete this comment."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
