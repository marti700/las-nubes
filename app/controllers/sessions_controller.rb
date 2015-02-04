class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by_username(params[:username])
    #if the user exists and the password entered is correct
    if @user && @user.authenticate(params[:password])
      #save the user id in a cookie (this allow the user stay logged in the site)
      session[:user_id] = @user.id
      #flash[:notice] = "Welcome back #{@user.username}"
      redirect_to "/files/index"
    else
      redirect_to "/welcome/index", notice: "your user name or password is invalid"
            end
    #end

  end

  def destroy
    session[:user_id] = nil
    redirect_to "/welcome/index", notice: "you log out successfuly"
  end

  private
end
