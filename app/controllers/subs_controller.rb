class SubsController < ApplicationController

  before_action :require_signin, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_mod, only: [:edit, :update, :destroy]

  def index
    @subs = Sub.all
  end

  def show
    @sub = Sub.find_by(id: params[:id])
    if @sub
      render :show
    else
      flash[:errors] ||= []
      flash[:errors] << "Could not find requested sub"
      redirect_to :root
    end
  end

  def new
    @sub = Sub.new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator_id = current_user.id
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] ||= []
      flash.now[:errors] += @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = Sub.find_by(id: params[:id])
    if @sub
      render :edit
    else
      flash[:errors] ||= []
      flash[:errors] << "Could not find requested sub"
      redirect_to :root
    end
  end

  def update
    @sub = Sub.find_by(id: params[:id])
    if @sub
      if @sub.update(sub_params)
        redirect_to sub_url(@sub)
      else
        flash.now[:errors] ||= []
        flash.now[:errors] += @sub.errors.full_messages
        render :edit
      end
    else
      flash[:errors] ||= []
      flash[:errors] << "Could not find requested sub"
      redirect_to :root
    end
  end

  def destroy
    @sub = Sub.find_by(id: params[:id])
    if @sub
      if @sub.destroy
        redirect_to :root
      else
        flash[:errors] ||= []
        flash[:errors] += @sub.errors.full_messages
        redirect_to sub_url(@sub)
      end
    else
      flash[:errors] ||= []
      flash[:errors] << "Could not find requested sub"
      redirect_to :root
    end
  end

  def sub_params
    params.require(:sub).permit(:title, :description)
  end

  def require_mod
    @sub = Sub.find_by(id: params[:id])
    unless @sub.moderator_id == current_user.id
      flash[:errors] ||= []
      flash[:errors] << "You are not authorized to modify this sub"
      redirect_to :root
    end
  end

end
