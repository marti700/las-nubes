class FilesController < ApplicationController
  require 'GDriveManager.rb'
  
  def index
  end

  def upload
    #gets the file reference from the browser 
    uploaded_io = params[:files][:Browse]
    
    logged_user = User.find(session[:user_id])
    google_action = GDriveManager.new
    begin
      #if the google access_token hava already expired 
      google_action.upload_to_gdrive uploaded_io, logged_user.google_access_code
    rescue ArgumentError #the provided access_token was invalid it says "Missing authorization code"
      #request a new access_token and updte the google_access_code field in the database for the currently logged user
      logged_user.update_attribute :google_access_code, GDriveManager.get_new_google_access_token(logged_user.google_refresh_token)["access_token"]
      #retry the upload
      google_action.upload_to_gdrive uploaded_io, logged_user.google_access_code
    end 
    render action: :index
  end
end
