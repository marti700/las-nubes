class UsersController < ApplicationController
  before_action :initialize_user_cloud_handlers
  before_action :initialize_dropbox_auth_flow, only: [:ask_for_dropbox_access, :get_dropbox_access_code]
  require 'GDriveManager'
  require 'dropbox_sdk'
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
    #ask for google access
    redirect_to @user_gdrive.client.authorization.authorization_uri.to_s 
    #redirect_to "files/index"
  end

  def ask_for_dropbox_access
    redirect_to @flow.start
  end

  def get_authorization_codes
    #exchange the authorization code for drive access token and refresh token
    user = User.find session[:user_id]
    @user_gdrive.client.authorization.code = params[:code]
    puts @user_gdrive.client.authorization.fetch_access_token!
    user.update_attribute :google_refresh_token, @user_gdrive.client.authorization.refresh_token
    user.update_attribute :google_access_code, @user_gdrive.client.authorization.access_token
    #byebug
    redirect_to "/users/ask_for_dropbox_access"
  end

  def get_dropbox_access_code
    #exchange the user permition code (obtained when the user grant acess to the app) for an access code
    @flow.finish params
    puts params
    redirect_to "/files/index"
  end
  
  private   
  def initialize_user_cloud_handlers
    @user_gdrive = GDriveManager.new
    #@user_dropbox = DropboxManager.new
  end
  
  def initialize_dropbox_auth_flow
    credentials = JSON.parse(File.read("#{Rails.root.to_s}/dropbox_secret.json"))
    @flow = DropboxOAuth2Flow.new credentials["secret"]["app_key"], credentials["secret"]["app_secret"], credentials["secret"]["redirect_uri"], session, :dropbox_auth_csrf_token 
  end
end
