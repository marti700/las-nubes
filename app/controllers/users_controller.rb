class UsersController < ApplicationController
  before_action :initialize_user_cloud_handlers
  require 'GDriveManager'
  require 'yaml'
  
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
    session[:user_id] = @user.id
    redirect_to "/users/ask_for_access"
    #puts `mkdir -p "#{Rails.root.to_s}/users/#{@user.username}"`
    #byebug
  end
  
  def ask_for_access
    redirect_to @user_gdrive.client.authorization.authorization_uri.to_s
  end

  def get_authorization_codes
    user = User.find session[:user_id]
    @user_gdrive.client.authorization.code = params[:code]
    puts @user_gdrive.client.authorization.fetch_access_token!
    user.update_attribute :google_refresh_token, @user_gdrive.client.authorization.refresh_token
    user.update_attribute :google_access_code, @user_gdrive.client.authorization.access_token
    #byebug
    redirect_to "/files/index"
  end
  
  private   
  def initialize_user_cloud_handlers
    @user_gdrive = GDriveManager.new
  end

=begin
  def user_params
    params.permit(:username, :email, :password, :password_confirmation, :salt)
  end
=end
end
