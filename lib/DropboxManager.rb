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

  #def get_all_files path="/"
  #  id_prefix = "b"
  #  all_files = Hash.new
  #  clean_result(dropbox_client.metadata(path)["contents"]).each do |file|
  #    all_files.store(id_prefix + @@dropbox_files.to_s, file)
  #    @@dropbox_files += 1
  #  end
  #  all_files
  #end
    def get_files
      files = Hash.new
      delta = dropbox_client.delta
      #puts delta['entries']
      files = files.merge clean_result delta['entries']
      files[:root]
      while delta['has_more']
        delta = dropbox_client.delta delta['cursor']
        files = files.merge(clean_result delta['entries']) do |key, oldval, newval|
          oldval + newval
        end
        p files[:root]
        #puts delta['has_more']
      end
      #p files
      files
    end

  def clean_result result
    files = {root: []}
    mime_type = YAML.load_file('mime_type_extension.yml')

    result.each do |file|
      #file_name = /[^\/]*.$/.match(file[0]).to_s #Takes the word after the last '/' which is the file name
      analyze = file[1]['path'].split '/'
      file_name = analyze.last

      if file[1]["is_dir"]
        file_type = "folder"
        file_mime = "dropbox/folder"
      else
        file_type = mime_type["#{file[1]['mime_type']}"]
        file_mime = file[1]["mime_type"]
      end
      file_size = file[1]["bytes"].to_s

      #Organize into the files hash
      if analyze.size == 2  #size 2 because slit split this '/photos' as ["","photos"]
        files[:root].push LNFile.new file_name, file_size, file_type, file_mime, file[1]["path"], 'dropbox'
      else
        file_parent = analyze[(analyze.size)-2].to_s
        puts "File parent is #{file_parent} get by #{file[0]} = #{ (analyze.size) -2 } analyze array is #{p analyze}"
        if files.has_key? file_parent
          puts "this key exist ---> #{file_parent} pushing --->#{file_name}"
          files["#{file_parent}"].push LNFile.new file_name, file_size, file_type, file_mime, file[1]["path"], 'dropbox'
        else
          puts "Creating key #{file_parent} and pushing --> #{file_name}"
          files["#{file_parent}"] = [LNFile.new(file_name, file_size, file_type, file_mime, file[1]["path"], 'dropbox')]
        end
      end
    end
    files
  end

  def create_folder a_folder_name, path
    #creates a folder in the given path
    dropbox_client.file_create_folder "#{path}/#{a_folder_name}"
  end

  def remaining_space
    #returns the space left in dropbox in bytes
    info = dropbox_client.account_info
    info["quota_info"]["quota"] - info["quota_info"]["normal"] - info["quota_info"]["shared"]
  end
end
