class FilesController < ApplicationController
  require 'FilesHandler'
  def index
    logged_user = User.find(session[:user_id])
    @logged_user_name = logged_user.username
    files = FilesHandler.new logged_user.google_access_code, logged_user.google_refresh_token, logged_user.dropbox_access_code
    respond_to do |format|
      format.html {
        @all_files = files.get_all_files
      }
      format.js {
        origin_path = params["pathOrigin"].split(':')
        @all_files = files.get_all_files origin_path.first, origin_path.last
        render "index.coffee.erb"
      }
    end

    
=begin    
    begin
      @all_files = file_list.get_all_files
    rescue ArgumentError
      logged_user.update_attribute :google_access_code, GDriveManager.get_new_google_access_token(logged_user.google_refresh_token)["access_token"]
      @all_files = google_action.get_all_files logged_user.google_access_code
    end
=end
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
    logged_user = User.find(session[:user_id])
    files_uploader = FilesHandler.new logged_user.google_access_code, logged_user.google_refresh_token, logged_user.dropbox_access_code
    respond_to do |format|
      format.json{
        response_data = Hash.new 
        response_data.store :google_client_id, files_uploader.gdrive.client.authorization.client_id
        response_data.store :google_scopes, files_uploader.gdrive.client.authorization.scope
        response_data.store :dropbox_access_token, logged_user.dropbox_access_code
        response_data.store :gdrive_remaining_space, files_uploader.gdrive.remaining_space
        response_data.store :dropbox_remaining_space, files_uploader.dropbox.remaining_space
        render json:  response_data
      }
    end

    
    #gets the file reference from the browser 
    #uploaded_io = params[:files][:Browse]
    #
    #logged_user = User.find(session[:user_id])
    #files_uploader = FilesHandler.new logged_user.google_access_code, logged_user.google_refresh_token, logged_user.dropbox_access_code
    #
    #
    #files_uploader.upload 'dropbox', uploaded_io

    #google_action = GDriveManager.new
    #begin
    #  #if the google access_token hava already expired 
    #  google_action.upload uploaded_io, logged_user.google_access_code
    #rescue ArgumentError #the provided access_token was invalid it says "Missing authorization code"
    #  #request a new access_token and updte the google_access_code field in the database for the currently logged user
    #  logged_user.update_attribute :google_access_code, GDriveManager.get_new_google_access_token(logged_user.google_refresh_token)["access_token"]
    #  #retry the upload
    #  google_action.upload uploaded_io, logged_user.google_access_code
    #end 
    #render action: :index
  end 
end
