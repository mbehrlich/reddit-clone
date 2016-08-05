class SessionsController < ApplicationController

  before_action :already_signedin, only: [:new, :create]
  before_action :require_signin, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(session_params[:username], session_params[:password])
    if @user.class == User
      login(@user)
      redirect_to :root
    else
      flash.now[:errors] ||= []
      flash.now[:errors] << @user
      @user = User.new(username: session_params[:username])
      render :new
    end
  end

  def destroy
    logout
    redirect_to :root
  end

  def session_params
    params.require(:user).permit(:username, :password)
  end


end
