class CommentsController < ApplicationController

  before_action :require_signin

  def new
    @comment = Comment.new(post_id: params[:post_id])
  end

  def show
    @comment = Comment.find_by(id: params[:id])
    @all_comments = @comment.post.comments_by_parent_id
    if @comment
      render :show
    else
      flash[:errors] ||= []
      flash[:errors] << "Could not find comment"
      redirect_to :root
    end
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.author_id = current_user.id
    if @comment.save
      redirect_to post_url(@comment.post)
    else
      flash.now[:errors] ||= []
      flash.now[:errors] += @comment.errors.full_messages
      render :new
    end
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id, :parent_comment_id)
  end


end
