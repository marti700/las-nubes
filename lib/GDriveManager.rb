require 'google/api_client'
require 'net/http'

class GDriveManager
  attr_accessor :client
  def initialize
    @client = Google::APIClient.new
    @client.authorization.client_id = '180099244229-i2mfb4k2tj022615ripnkegqep3n4t15.apps.googleusercontent.com'
    @client.authorization.client_secret = 'kOd5dswJJE6tfBI0cCa5oI6R'
    @client.authorization.redirect_uri = 'https://lasnubes.ngrok.com/users/get_authorization_codes'
    @client.authorization.scope = 'https://www.googleapis.com/auth/drive' 
  end

  def self.get_new_google_access_token refresh_token, grant_type='refresh_token'
    #obtain a new google access_token from google
    
    data = JSON.parse(File.read("/home/teodoro/Documents/Projects/RubyProjects/las_nubes/client_secret.json"))
    uri = URI('https://www.googleapis.com/oauth2/v3/token')
    response = Net::HTTP.post_form(uri, 'client_id' => data["web"]["client_id"], 'client_secret' => data["web"]["client_secret"], 
                                   'refresh_token' => refresh_token, 'grant_type' => grant_type)
    return JSON.parse(response.body)
  end
  
  def upload_to_gdrive a_file, google_access_code
    #uploads files to google drive
    
    self.client.authorization.access_token = google_access_code
    drive = self.client.discovered_api('drive', 'v2')
    file = Google::APIClient::UploadIO.new(a_file, 'image/png')

    metadata = {
      title: a_file.original_filename,
      description: "it's Up yay!",
      mimeType: "image/png"
    }

    result = self.client.execute(
      api_method: drive.files.insert,
      body_object: metadata,
      media: file,
      parameters: {
        'uploadType' => 'multipart'
      }
    ) 
    return :invalid_access_code if result.status != 200 
    puts result.data.to_s
  end
end

#puts GDriveManager.get_new_google_access_token("1/0i9klxuCqICiwknXiw0IpPEl_GXdOMcj4YMGC2ROB-EMEudVrK5jSpoR30zcRFq6")
=begin
puts l.get_new_google_access_token('180099244229-i2mfb4k2tj022615ripnkegqep3n4t15.apps.googleusercontent.com',
                                   'kOd5dswJJE6tfBI0cCa5oI6R',
                                   '1/BGezHapp1oiu9022MMo6gmXHqE4s6Rmh6vVubloBYw8MEudVrK5jSpoR30zcRFq6')
=end
#https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=TOKEN  #to see if the access token is still valid
