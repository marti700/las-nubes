class FilesController < ApplicationController
  require 'FilesHandler'
  def index
    logged_user = User.find(session[:user_id])
    @logged_user_name = logged_user.username
    files = FilesHandler.new logged_user.google_access_code, logged_user.google_refresh_token, logged_user.dropbox_access_code
    gon.files = files.get_all_files
  end

  def create_folder
    logged_user = User.find(session[:user_id])
    files = FilesHandler.new logged_user.google_access_code, logged_user.google_refresh_token, logged_user.dropbox_access_code

    respond_to do |format|
      format.js {
        origin_path = params[:origin].split(':')
        puts params
        files.create_folder params[:folder_name], params[:origin]
        @all_files = files.get_all_files origin_path.first, origin_path.last
        render "index.coffee.erb"
      }
    end
  end

  def upload
  end

    def get_access_tokens
      logged_user = User.find(session[:user_id])
      drives_data = FilesHandler.new logged_user.google_access_code, logged_user.google_refresh_token, logged_user.dropbox_access_code
      #logged_user.update_attribute :google_access_code, GDriveManager.get_new_google_access_token(logged_user.google_refresh_token)["access_token"]
      respond_to do |format|
        format.json{
          response_data = Hash.new
          response_data.store :google_access_token, drives_data.gdrive.get_new_google_access_token(logged_user.google_refresh_token)
          response_data.store :dropbox_access_token, logged_user.dropbox_access_code
          response_data.store :gdrive_remaining_space, drives_data.gdrive.remaining_space
          response_data.store :dropbox_remaining_space, drives_data.dropbox.remaining_space
          render json:  response_data
        }
      end
    end
end
