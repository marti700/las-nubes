require 'GDriveManager'
require 'DropboxManager'

class FilesHandler
  attr_accessor :gdrive, :dropbox
  def initialize google_access_code, google_refresh_token, dropbox_access_token
    @@file_id = 1;
    @gdrive = GDriveManager.new
    @dropbox = DropboxManager.new(dropbox_access_token)

    #provide google access_token and refresh token to @gdrive, to permit api calls
    @gdrive.client.authorization.access_token = google_access_code
    @gdrive.client.authorization.refresh_token = google_refresh_token
  end

  def get_all_files origin=nil, path='/'
    
    if origin == 'gdrive'
      path = 'root' if path == '/'
      puts "#{path} from files handler get all files"
      gdrive.get_all_files path
    elsif origin == 'dropbox'
      dropbox.get_all_files path
    else
      gdrive.get_all_files.merge(dropbox.get_all_files)
    end
  end
  

  def upload where_to_upload, a_file
    if where_to_upload == 'gdrive'
      gdrive.upload a_file 
    elsif where_to_upload == 'dropbox'
      dropbox.upload a_file
    end
  end
end
