class SessionsController < ApplicationController
  def new
  end
  
  def create
    # validates user is correct
    # saves session
    found_user = User.find_by(email: params[:session][:email].downcase)
    if found_user && found_user.authenticate(params[:session][:password])
      flash[:success] = "Successfully signed in"
      sign_in found_user
      redirect_back_or user_path(found_user)
    else
      flash.now[:error] = "Error signing in #{params[:session][:email]}"
      render 'new'
    end       
  end
  
  def destroy
    signout
    redirect_to root_path
  end
  
 
end
