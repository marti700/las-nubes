class UsersController < ApplicationController
  def create
    @user = User.new
    @user.username = params[:username]
    @user.email = params[:email]
    @user.password = params[:password]
    @user.salt = params[:salt]
    if @user.save
      flash[:notice] = "Welcome aboard #{@user.username}"
      flash[:color] = "valid"
    else
      flash[:notice] = "Opps, something went wrong with you request, looks like the form is invalid"
      flash[:color] = "invalid"
    end
    #byebug
  end
  
  private
=begin
  def user_params
    params.permit(:username, :email, :password, :password_confirmation, :salt)
  end
=end
end
