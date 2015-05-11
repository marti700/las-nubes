class @GdriveActionHandler
  constructor: (@token) ->

  #loads the gdrive API client to start upload
  uploadFile: (aFile, uploadStatus, progressBar) =>
    metadata = {
      'title': aFile.name
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
        this.insertFile(aFile, jqXHRObject.getResponseHeader('Location'), @token.access_token, uploadStatus, progressBar)
    })

  #upload the file to upload_uri obtainde by uploadFile function
  insertFile: (file, upload_uri, access_token, uploadStatus, progressBar) =>
    $.ajax({
      url: upload_uri,
      type: 'PUT'
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
      success: ()->
        if uploadStatus #if uploadStatus was passed
          uploadStatus.text 'Done!'
    })
