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
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(name: params[:name])
      flash[:success] = "User updated successfully"
      redirect_to @user
    else
      flash[:error] = "User update went wrong"
      render 'edit'
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation) 
  end
end
