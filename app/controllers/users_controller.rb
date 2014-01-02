class UsersController < ApplicationController
  def new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user][:name], params[:user][:email], params[:user][:password], params[:user][:password_confirmation])
    if @user.save
    else
      render 'new'
    end
    
  end
end
