require 'google/api_client'
require 'net/http'
require 'LNFile'

class GDriveManager
  attr_accessor :client
  def initialize
    data = JSON.parse(File.read("/home/teodoro/Documents/Projects/RubyProjects/las_nubes/client_secret.json"))
    @@gdrive_files = 0
    @client = Google::APIClient.new
    @client.authorization.client_id = data['web']['client_id']
    @client.authorization.client_secret = data['web']['client_secret']
    @client.authorization.redirect_uri = data['web']['redirect_uris'][0]
    @client.authorization.scope = 'https://www.googleapis.com/auth/drive'
  end

  def get_new_google_access_token refresh_token, grant_type='refresh_token'
    #obtain a new google access_token from google

    data = JSON.parse(File.read("/home/teodoro/Documents/Projects/RubyProjects/las_nubes/client_secret.json"))
    uri = URI('https://www.googleapis.com/oauth2/v3/token')
    response = Net::HTTP.post_form(uri, 'client_id' => data["web"]["client_id"], 'client_secret' => data["web"]["client_secret"],
                                   'refresh_token' => refresh_token, 'grant_type' => grant_type)
    return JSON.parse(response.body)
  end

  def upload a_file
    #uploads files to google drive

    #self.client.authorization.access_token = google_access_code
    drive = self.gdrive.client.discovered_api('drive', 'v2')
    file = Google::APIClient::UploadIO.new(a_file, 'image/png')

    metadata = {
      title: a_file.original_filename,
      description: "it's Up yay!",
      mimeType: "image/png"
    }

    result = self.gdrive.client.execute(
      api_method: drive.files.insert,
      body_object: metadata,
      media: file,
      parameters: {
        'uploadType' => 'multipart'
      }
    )
    return :invalid_access_code if result.status != 200
  end

  #def get_files_from_folder path='root'
  #  id_prefix = 'a'
  #  all_files = Hash.new
  #  #self.client.authorization.access_token = google_access_code
  #  drive = self.client.discovered_api('drive', 'v2')
  #  result = self.client.execute(
  #    api_method: drive.files.list,
  #    parameters: {q: "'#{path}' in parents and trashed=false"}
  #  )

  #  if result.status == 200
  #    clean_result(result.data.items).each do |file|
  #      all_files.store(id_prefix + @@gdrive_files.to_s, file)
  #      @@gdrive_files += 1
  #    end
  #  else
  #    puts "An error occurred: #{result.data['error']['message']}"
  #  end
  #  all_files
  #end
  def get_files
    #Gets all Files from the users gdrive
    id_prefix = 'a'
    all_files = Hash.new
    drive = self.client.discovered_api('drive', 'v2')
    result = self.client.execute(
      api_method: drive.files.list,
      parameters: { maxResults: 1000,
                    q: "trashed=false"
                  }
    )

    if result.status == 200
      clean_result(result.data.items)
    else
      puts "An error occured: #{ result.data['error']['message'] }"
    end
  end

  def clean_result result, keys_are_folders_name = true
    #transform users drive files metadata in LNFiles and groups them by folders
    mime_type = YAML.load_file('mime_type_extension.yml')
    files = { root: [] }
    result.each do |file|
      file_id = Time.now.to_i.to_s[-4..-1]+rand(1000..9999).to_s+'driv'
      file_name = file.title
      file_size = file.file_size
      file.mime_type == 'application/vnd.google-apps.folder'? file_type = 'folder' : file_type = file.file_extension
      download_link = nil
      #if the file has a export_links property means that it can only be downloaded using one of the links provided
      #in the export links see: https://developers.google.com/drive/web/manage-downloads
      if file.export_links
        file_export = file.export_links.to_hash
        file_export.each_pair do |key, value|
          #if the export link match the file mime_type use that export link to as a download link
          if file.mime_type.match(/(vnd.google-apps.document|vnd.google-apps.presentation|vnd.google-apps.spreadsheet)/)
            download_link = value
            break
          end
        end
      end
      
      #the each method will not process empty arrays
      files[:root].push LNFile.new file_id, file_name, file_size, file_type, file.mimeType, file.id, 'gdrive', download_link if file.parents.empty?
      file.parents.each do |parent|
        if parent.isRoot
          files[:root].push LNFile.new file_id, file_name, file_size, file_type, file.mime_type, file.id, 'gdrive', download_link
        elsif files.has_key? parent['id']
          #puts "this key exist ---> #{parent['id']} pushing --->#{file_name}"
          files["#{parent['id'].to_s}"].push LNFile.new file_id, file_name, file_size, file_type, file.mime_type, file.id, 'gdrive', download_link
        else
          #puts "Creating key #{parent['id']} and pushing --> #{file_name}"
          files["#{parent['id'].to_s}"] = [LNFile.new(file_id, file_name, file_size, file_type, file.mimeType, file.id, 'gdrive', download_link)]
        end
      end
    end
   files
  end

  def remaining_space
    #returns the space left in google drive in bytes
    drive = self.client.discovered_api('drive', 'v2')
    result = self.client.execute(
      api_method: drive.about.get
    )

    if result.status == 200
      result.data.quota_bytes_total - result.data.quota_bytes_used
    else
      puts "An error occurred: #{result.data['error']['message']}"
    end
  end

  def create_folder a_folder_name, path
    #creates a folder in a given path (path is a folder id), if path = '/' (which is cleary not a file id) file is created in root

    drive = self.client.discovered_api('drive', 'v2')

    metadata = {
      title: a_folder_name,
      mimeType: "application/vnd.google-apps.folder",
    }

    result = self.client.execute(
      api_method: drive.files.insert,
      body_object: metadata,
    )
    if path != '/'
      metadata = result.data
      metadata.parents = [{id: path}] if result.status == 200

      update = self.client.execute(
        api_method: drive.files.update,
        body_object: metadata,
        parameters: {
          fileId: metadata.id
        }
      )

      if update.status == 200
        puts "done!"
      else
        puts "An error occurred: #{result.data['error']['message']}"
      end
    end
  end
end

#puts GDriveManager.get_new_google_access_token("1/0i9klxuCqICiwknXiw0IpPEl_GXdOMcj4YMGC2ROB-EMEudVrK5jSpoR30zcRFq6")
=begin
puts l.get_new_google_access_token('180099244229-i2mfb4k2tj022615ripnkegqep3n4t15.apps.googleusercontent.com',
                                   'kOd5dswJJE6tfBI0cCa5oI6R',
                                   '1/BGezHapp1oiu9022MMo6gmXHqE4s6Rmh6vVubloBYw8MEudVrK5jSpoR30zcRFq6')
=end
#https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=TOKEN  #to see if the access token is still valid
