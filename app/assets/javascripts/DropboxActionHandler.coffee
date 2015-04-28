class @DropboxActionHandler
  constructor:(@access_token)->
    console.log "before declaring client"
    this.dropbox_client = new Dropbox.Client({token: @access_token})
    console.log "after declaring client"

  uploadFile: =>
    console.log "at upload"
    #take the reference to the selected file 'files-explorer' is an input type file
    file = document.getElementById('files-explorer').files[0]
    console.log file.name
    this.dropbox_client.writeFile(file.name, file, (error, stat) ->
      if error
        return "something wrong happend"
    )



