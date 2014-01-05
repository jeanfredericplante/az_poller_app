class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end
  
  def new
    redirect_to user_path(current_user) if signed_in?  
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Account successfully created"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation) 
  end
end
