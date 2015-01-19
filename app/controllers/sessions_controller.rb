class SessionsController < ApplicationController
  require 'GDriveManager'
  before_action :initialize_user_cloud_handlers

  def new
    redirect_to @user_gdrive.client.authorization.authorization_uri.to_s
  end

  def create
    @user_gdrive.client.authorization.code = params[:code]
    puts @user_gdrive.client.authorization.fetch_access_token!
  end

  private
   def initialize_user_cloud_handlers
     @user_gdrive = GDriveManager.new
   end
end
