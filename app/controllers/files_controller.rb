class FilesController < ApplicationController
  require 'GDriveManager.rb'
  
  def index
  end

  def upload
    puts params
    uploaded_io = params[:files][:Browse]
    @user = GDriveManager.new
    @user.upload_to_gdrive uploaded_io
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      puts file.write(uploaded_io.read)
    end
    flash[:notice] = "file successfully uploaded"
    render action: :index
    #puts params
    #puts "ya llego la vaina"
  end
end
