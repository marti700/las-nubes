require 'dropbox_sdk'
require 'LNFile'

class DropboxManager
  attr_accessor :dropbox_client
  def initialize dropbox_access_token
    @dropbox_client = DropboxClient.new dropbox_access_token
  end

  def upload a_file
    result = dropbox_client.put_file a_file.original_filename, a_file.read
  end

  def get_all_files
    clean_result dropbox_client.metadata('/')["contents"]
  end

  def clean_result result
    files = Array.new
    result.each do |file|
      file_and_extension = file["path"].split('/').last #Takes the word after the last /
      file_extension = file_and_extension.split '.'
      file_name = file_extension[0]
      file_type = file_extension[1]
      file_size = file["bytes"].to_s
      files.push LNFile.new file_name, file_size, file_type   
    end
    files
  end
end

