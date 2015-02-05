class FilesController < ApplicationController
  require 'GDriveManager.rb'
  
  def index
  end

  def upload
    puts params
    uploaded_io = params[:files][:Browse]
    google_action = GDriveManager.new
    if google_action.upload_to_gdrive(uploaded_io, User.find(session[:user_id]).google_access_code) == :invalid_access_code
      needed_data = JSON.parse(File.read("#{Rails.root.to_s}/client_secret.json"))
      puts google_action.get_new_google_access_token needed_data["client_id"], needed_data["client_secret"], User.find(session[:user_id]).google_refresh_token
    end
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      puts file.write(uploaded_io.read)
    end
    flash[:notice] = "file successfully uploaded"
    render action: :index
    #puts params
    #puts "ya llego la vaina"
  end
end
