class FilesController < ApplicationController
  require 'GDriveManager.rb'
  
  def index
  end

  def upload
    #gets the file reference from the browser 
    uploaded_io = params[:files][:Browse]
    
    google_action = GDriveManager.new
    #if the google access_token hava already expired 
    if google_action.upload_to_gdrive(uploaded_io, User.find(session[:user_id]).google_access_code) == :invalid_access_code
      #request a new access_token
      GDriveManager.get_new_google_access_token User.find(session[:user_id]).google_refresh_token
    end
    
    #File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
     # puts file.write(uploaded_io.read)
    #end
    #flash[:notice] = "file successfully uploaded"
    render action: :index
    #puts params
    #puts "ya llego la vaina"
  end
end
