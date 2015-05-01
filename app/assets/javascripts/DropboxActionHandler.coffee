class @DropboxActionHandler
  constructor:(@access_token) ->
    this.dropbox_client = new Dropbox.Client({token: @access_token})

  uploadFile:(aFile) =>
    this.dropbox_client.writeFile(aFile.name, aFile, (error, stat) ->
      if error
        return showError(error)
    )



