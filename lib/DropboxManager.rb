require 'dropbox_sdk'
class DropboxManager
  attr_accessor :dropbox_client
  def initialize dropbox_access_token
    @dropbox_client = DropboxClient.new dropbox_access_token
  end

  def upload a_file
    result = dropbox_client.put_file a_file.original_filename, a_file.read
  end
end

