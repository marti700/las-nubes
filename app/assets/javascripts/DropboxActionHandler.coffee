class @DropboxActionHandler
  constructor:(@access_token) ->
    this.dropbox_client = new Dropbox.Client({token: @access_token})
    console.log this.dropbox_client

  uploadFile:(aFile, path, uploadStatus, progressBar, modifDOMEle) =>
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

      if stat.isFolder
        childrens = stat.path.math(/[^\/]*.$/)[0].toString().replace(/\s/g,'-')
      else
        childrens = null
      fr = "<tr class='ft-row' childrens=#{childrens}>"+
           "<td> #{stat.name}</td>"+
           "<td> #{stat.size}</td>"+
           "<td> #{stat.mimeType}</td></tr>"
      #modifDOMEle is a jquery object (a DOM element) passed to be modified
      modifDOMEle.append fr
    )

  download: (filePath, fileMimeType, downloadStatus, progressBar) =>
    fileName = filePath.match(/[^\/]*.$/)[0].toString()

    #add progress event to dropbox XmlHttpRequest object
    xhrListener = (dbXhr) ->
      dbXhr.xhr.onprogress = (evt) ->
        progress = parseInt (evt.loaded/evt.total)*100
        progressBar.css 'width', "#{progress}%"
        progressBar.text "#{progress}%"
      dbXhr.xhr.onloadend = (evt) ->
        downloadStatus.text 'Done!'

      return true

    this.dropbox_client.onXhr.addListener xhrListener #actually adding the progress event

    #Download file
    this.dropbox_client.readFile "#{filePath}", {blob: true}, (error,data) ->
      if error
        return showError error

      #Using download.js to trigger the browser download
      #see: http://danml.com/download.html
      download data, fileName, fileMimeType #trigger browser download mechanism
