class PostsController < ApplicationController

  before_action :require_signin, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_author, only: [:edit, :update, :destroy]

  def show
    @post = Post.find_by(id: params[:id])
    @all_comments = @post.comments_by_parent_id
    if @post
      render :show
    else
      flash[:errors] ||= []
      flash[:errors] << "Could not find requested post"
      redirect_to :root
    end
  end

  def new
    @post = Post.new
    @current_sub = params[:sub_id]
    @subs = Sub.all
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] ||= []
      flash.now[:errors] += @post.errors.full_messages
      @current_sub = params[:sub_id].to_i
      @subs = Sub.all
      render :new
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
    @subs = Sub.all
    if @post
      render :edit
    else
      flash[:errors] ||= []
      flash[:errors] << "Could not find requested post"
      redirect_to :root
    end
  end

  def update
    @post = Post.find_by(id: params[:id])
    if @post
      if @post.update(post_params)
        redirect_to post_url(@post)
      else
        flash.now[:errors] ||= []
        flash.now[:errors] += @post.errors.full_messages
        @subs = Sub.all
        render :edit
      end
    else
      flash[:errors] ||= []
      flash[:errors] << "Could not find requested post"
      redirect_to :root
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    if @post
      if @post.destroy
        redirect_to :root
      else
        flash[:errors] ||= []
        flash[:errors] += @post.errors.full_messages
        redirect_to post_url(@post)
      end
    else
      flash[:errors] ||= []
      flash[:errors] << "Could not find requested post"
      redirect_to :root
    end
  end

  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end

  def require_author
    @post = Post.find_by(id: params[:id])
    unless @post.author_id == current_user.id
      flash[:errors] ||= []
      flash[:errors] << "You are not authorized to modify this post"
      redirect_to :root
    end
  end

  # Deprecated
  def require_author_or_mod
    @post = Post.find_by(id: params[:id])
    unless @post.author_id == current_user.id || @post.sub.moderator == current_user.id
      flash[:errors] ||= []
      flash[:errors] << "You are not authorized to modify this post"
      redirect_to :root
    end
  end

end
