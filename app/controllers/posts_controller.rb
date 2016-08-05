class PostsController < ApplicationController

  before_action :require_signin, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_author, only: [:edit, :update]
  before_action :require_author_or_mod, only: [:destroy]

  def show
    @post = Post.find_by(id: params[:id])
    if @post
      render :show
    else
      flash[:errors] ||= []
      flash[:errors] << "Could not find requested post"
      redirect_to :root
    end
  end

  def new
    @post = Post.new(sub_id: params[:sub_id])
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] ||= []
      flash.now[:errors] += @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
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
    params.require(:post).permit(:title, :url, :content, :sub_id)
  end

  def require_author
    @post = Post.find_by(id: params[:id])
    unless @post.author_id == current_user.id
      flash[:errors] ||= []
      flash[:errors] << "You are not authorized to modify this post"
      redirect_to :root
    end
  end

  def require_author_or_mod
    @post = Post.find_by(id: params[:id])
    unless @post.author_id == current_user.id || @post.sub.moderator == current_user.id
      flash[:errors] ||= []
      flash[:errors] << "You are not authorized to modify this post"
      redirect_to :root
    end
  end

end
