require 'google/api_client'

class GDriveManager
  attr_accessor :client
  def initialize
    @client = Google::APIClient.new
    @client.authorization.client_id = '180099244229-i2mfb4k2tj022615ripnkegqep3n4t15.apps.googleusercontent.com'
    @client.authorization.client_secret = 'kOd5dswJJE6tfBI0cCa5oI6R'
    @client.authorization.redirect_uri = 'https://lasnubes.ngrok.com/sessions/create'
    @client.authorization.scope = 'https://www.googleapis.com/auth/drive' 
  end

  def get_new_google_access_token client_id, client_secret, refresh_token, grant_type='refresh_token'
    uri = URI('https://www.googleapis.com/oauth2/v3/token')
    response = Net::HTTP.post_form(uri, 'client_id' => client_id, 'client_secret' => client_secret, 'refresh_token' => refresh_token, 'grant_type' => 'refresh_token')
    JSON.parse(response.body)
  end
  
  def upload_to_gdrive a_file
    drive = client.discovered_api('drive', 'v2')
    file = Google::APIClient::UploadIO.new(a_file, 'image/png')

    metadata = {
      title: a_file.original_filename,
      description: "it's Up yay!",
      mimeType: "image/png"
    }

    result = client.execute(
      api_method: drive.files.insert,
      body_object: metadata,
      media: file,
      parameters: {
        'uploadType' => 'multipart'
      }
    )

  puts JSON.parse(result.data)
  end
end
=begin
puts l.get_new_google_access_token('180099244229-i2mfb4k2tj022615ripnkegqep3n4t15.apps.googleusercontent.com',
                                   'kOd5dswJJE6tfBI0cCa5oI6R',
                                   '1/BGezHapp1oiu9022MMo6gmXHqE4s6Rmh6vVubloBYw8MEudVrK5jSpoR30zcRFq6')
=end
#https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=TOKEN  #to see if the access token is still valid
