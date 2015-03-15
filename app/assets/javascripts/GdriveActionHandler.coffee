class @GdriveActionHandler
  constructor: (@client_id, @scopes) ->
    $(window).load ->
      this.handleClientLoad()
  
  #called when the client library is loaded to start the auth flow
  handleClientLoad: =>
    window.setTimeout this.checkAuth,1
  #to check if the current user hava authorized the application
  checkAuth: =>
    gapi.auth.authorize(
      {
        'client_id': @client_id, 'scope': @scopes, 'immediate': true
      },
      this.handleAuthResult
    )
  # this is called when the authorization server replies
  # if the user has already authenticated then all is fine
  # if the user is not authenticated then the user will be
  # asked to authenticate
  handleAuthResult: (authResult) =>
    if authResult && !authResult.error
      console.log "all fine!"
    else
      console.log "Authentication needed"
      gapi.auth.authorize(
        {
          'client_id': @client_id, 'scope': @scopes, 'immediate': false
        },
        this.handleAuthResult
      )
  #start authentication flow
  authenticate: ->
    this.handleClientLoad()

  #loads the gdrive API client to start upload
  uploadFile: (evt) ->
    #GdriveUploader::authenticate()
    gapi.client.load('drive', 'v2', -> 
      #take the reference to the selected file 'files-explorer' is an input type file
      file = document.getElementById('files-explorer').files[0] 
      #file = $('#files_Browser').files[0] 
      console.log this
      GdriveActionHandler::insertFile(file) #calls the method that will actually upload the file
    )
  #Insert new file in drive 
  insertFile: (fileData, callback) ->
    boundary = '-------314159265358979323846'
    delimiter = "\r\n--" + boundary + "\r\n"
    close_delim = "\r\n--" + boundary + "--"

    #decide if the file will be uploaded to root or inside a folder
    console.log $('#currentpath').text()
    if $('#currentpath').text() == '/' 
      contentType = fileData.type || 'application/octect-stream'
      metadata = {
        'title': fileData.name,
        'mimeType': contentType,
      }

    else
      parent = $('#currentpath').text().split(':')[1] #file will be uploaded inside the foder(s) with this id
      contentType = fileData.type || 'application/octect-stream'
      metadata = {
        'title': fileData.name,
        'mimeType': contentType,
        'parents': [{'id': parent}]
      }
    console.log parent
    
    reader = new FileReader()
    reader.readAsBinaryString fileData
    reader.onload = (e) ->
      base64Data = btoa reader.result
      multipartRequestBody = 
      delimiter +
      'Content-Type: application/json\r\n\r\n' +
      JSON.stringify(metadata) +
      delimiter +
      'Content-Type: ' + contentType + '\r\n' +
      'Content-Transfer-Encoding: base64\r\n' +
      '\r\n' +
      base64Data +
      close_delim;
      
      request = gapi.client.request({
        'path': '/upload/drive/v2/files',
        'method': 'POST',
        'params': {'uploadType': 'multipart'},
        'headers': {
        'Content-Type': 'multipart/mixed; boundary="' + boundary + '"'
        },
        'body': multipartRequestBody});
      if !callback
        callback = (file) ->
          console.log file
      request.execute callback
