class UsersController < ApplicationController

  before_action :already_signedin, only: [:new, :create]
  before_action :require_signin, only: [:show, :destroy]

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] ||= []
      flash.now[:errors] += @user.errors.full_messages
      render :new
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user.id != current_user.id
      flash[:errors] ||= []
      flash[:errors] << "You are not the correct user"
      redirect_to :root
    else
      if @user.destroy
        redirect_to :root
      else
        flash[:errors] ||= []
        flash[:errors] << "Could not delete for some reason"
        redirect_to :root
      end
    end
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
