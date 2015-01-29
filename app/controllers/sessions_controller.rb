class SessionsController < ApplicationController
  require 'GDriveManager'
  before_action :initialize_user_cloud_handlers

  def new
    redirect_to @user_gdrive.client.authorization.authorization_uri.to_s
  end

  def create
    #@user = User.find_by_username(params[:username])
    #if the user exists and the password entered is correct
    #if @user && @user.authenticate(params[:password])
      #save the user id in a cookie (this allow the user stay logged in the site)
     # session[:user_id] = @user.id
      #flash[:notice] = "Welcome back #{@user.username}"
    #else
      #redirect_to "/welcome/index", notice: "your user name or password is invalid"
      @user_gdrive.client.authorization.code = params[:code]
      puts @user_gdrive.client.authorization.fetch_access_token!
    #end

  end

  def destroy
    session[:user_id] = nil
    redirect_to "/welcome/index", notice: "you log out successfuly"
  end

  private
   def initialize_user_cloud_handlers
     @user_gdrive = GDriveManager.new
   end
end
