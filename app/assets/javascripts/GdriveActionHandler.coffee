class @GdriveActionHandler
  constructor: (@token) ->

  #loads the gdrive API client to start upload
  uploadFile: (aFile, path, uploadStatus, progressBar, modifDOMEle) =>
    if path == '/'
      metadata = {
        'title': aFile.name
      }
    else
      metadata = {
        'title': aFile.name
        'parents': [id: path]
      }

    #make a resumable upload request to drive
    $.ajax({
      url: 'https://www.googleapis.com/upload/drive/v2/files?uploadType=resumable',
      type: 'POST',
      headers: {'X-Upload-Content-Type': aFile.type || 'application/octetc-stream',
      #'X-Upload-Content-Length': aFile.size,
      'Content-Type': 'application/json'
      'Authorization': "Bearer #{@token.access_token}"
      },
      data: JSON.stringify(metadata)
      success: (data, textStaus, jqXHRObject ) =>
        #upload the file
        this.insertFile(aFile, jqXHRObject.getResponseHeader('Location'), @token.access_token, uploadStatus, progressBar).success (data) ->
          childrens = if data.mimeType == 'application/vnd.google-apps.folder' then childrens = data.id else childrens = null
          fr = "<tr class='ft-row' childrens= #{childrens}>"+
                "<td> #{data.title}</td>"+
                "<td> #{data.fileSize}</td>"+
                "<td> #{data.mimeType}</td></tr>"
          modifDOMEle.append fr #modifDOMEle is jquery object(a DOM element) passed to be modified
    })

  #upload the file to upload_uri obtainde by uploadFile function
  insertFile: (file, upload_uri, access_token, uploadStatus, progressBar) =>
    $.ajax({
      url: upload_uri,
      type: 'PUT'
      crossDomain: true
      headers: {
        'Content-Length': file.size
        'Authorization': "Bearer #{access_token}"
      }
      #binds onprogress event to jquery XmlHttpRequest object
      xhr: () ->
        #get jquery XmlHttpRequest object
        xhr = $.ajaxSettings.xhr()
        # Set the onprogress evt
        xhr.upload.onprogress = (evt) ->
          if progressBar # if progressBar was passed
            progress = parseInt((evt.loaded/evt.total) *100)
            progressBar.css 'width',"#{progress}%"
            progressBar.text "#{progress}%"

        return xhr

      processData: false
      data: file
      success: ->
        if uploadStatus #if uploadStatus was passed
          uploadStatus.text 'Done!'
    })

  download: (fileId, fileTitle, fileMimeType, fileDownloadUrl, downloadStatus, progressBar,fileSize) =>
    #Download a File from google drive
    #fileId is the file id of the file to be downloaded
    #fileTitle is the file name provided by the caller, when downloaded the file will have this name
    #fileMimeType is the mime type of the file to be downloaded (if not sure check the metadata of the file)
    #fileDownloadUrl is the url of the file export link to download documents created in drive if
    #fileDownloadUrl is not provided is assumed that is a file that has been uploaded to drive so,
    #the file download will be attempted using a ulr of the kind https://www.googleapis.com/drive/v2/files/#{fileId}?alt=media
    if fileDownloadUrl == 'null' || undefined
      fileDownloadUrl = "https://www.googleapis.com/drive/v2/files/#{fileId}?alt=media"

    #I was having trouble with $.ajax and the file binary data retourned from google
    #So I implemented it old school (I guess is not that old) using a pure XMLHttpRequest
    xhr = new XMLHttpRequest

    #updates the progress bar element
    xhr.onprogress = (evt)->
      #console.log evt.lengthComputable
      #console.log evt.loaded
      #console.log evt.total
      if evt.lengthComputable && progressBar #if progressBar was passed
        progress = parseInt((evt.loaded/evt.total) *100)
        console.log progress
        progressBar.css 'width',"#{progress}%"
        progressBar.text "#{progress}%"

    xhr.open 'GET', fileDownloadUrl, true
    xhr. responseType = 'blob'
    xhr.setRequestHeader 'Authorization', "Bearer #{@token.access_token}"

    xhr.onload = ->
      #by the end of the following line b willb
      #a blob representation of the file being downloaded
      b = this.response
      #Using download.js to trigger the browser download
      #see: http://danml.com/download.html
      download b, fileTitle, fileMimeType
      downloadStatus.text 'Done!'

    xhr.send()
