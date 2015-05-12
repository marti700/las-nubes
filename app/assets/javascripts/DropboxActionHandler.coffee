class @DropboxActionHandler
  constructor:(@access_token) ->
    this.dropbox_client = new Dropbox.Client({token: @access_token})

  uploadFile:(aFile, path, uploadStatus, progressBar) =>
    #add progress event to dropbox XmlHttpRequest object
    xhrListener = (dbXhr) ->
      dbXhr.xhr.upload.onprogress = (evt) ->
        progress = parseInt (evt.loaded/evt.total)*100
        progressBar.css 'width', "#{progress}%"
        progressBar.text "#{progress}%"
      dbXhr.xhr.upload.onloadend = (evt) ->
        uploadStatus.text 'Done!'

      return true
    this.dropbox_client.onXhr.addListener xhrListener
    this.dropbox_client.writeFile("#{path}/#{aFile.name}", aFile, (error, stat) ->
      if error
        return showError(error)
    )



