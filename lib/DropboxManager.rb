require 'dropbox_sdk'
require 'LNFile'

class DropboxManager
  attr_accessor :dropbox_client
  def initialize dropbox_access_token
    @@dropbox_files = 0;
    @dropbox_client = DropboxClient.new dropbox_access_token
  end

  def upload a_file
    result = dropbox_client.put_file a_file.original_filename, a_file.read
  end

  def get_all_files path="/"
    id_prefix = "b"
    all_files = Hash.new
    clean_result(dropbox_client.metadata(path)["contents"]).each do |file|
      all_files.store(id_prefix + @@dropbox_files.to_s, file) 
      @@dropbox_files += 1
    end
    all_files
  end

  def clean_result result
    files = Array.new
    result.each do |file|
      file_name = file["path"].split('/').last #Takes the word after the last '/' which is the file name
      file["is_dir"] ? file_type = "folder" : file_type = file["mime_type"].split('/').last 
      file_size = file["bytes"].to_s
      files.push LNFile.new file_name, file_size, file_type, file["path"], 'dropbox'   
    end
    files
  end
  def create_folder a_folder_name, path
    #creates a folder in the given path
    dropbox_client.file_create_folder "#{path}/#{a_folder_name}"
  end
  
  def space_left
    #returns the space left in dropbox in bytes
    info = dropbox_client.account_info
    info["quota_info"]["quota"] - info["quota_info"]["normal"] - info["quota_info"]["shared"]
  end
end
