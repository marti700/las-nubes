class FilesController < ApplicationController
  require 'GDriveManager.rb'
  
  def index
  end

  def upload
    puts params
    uploaded_io = params[:files][:Browse]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    flash[:notice] = "Post successfully created"
    render action: :index
    #puts params
    #puts "ya llego la vaina"
  end
end
