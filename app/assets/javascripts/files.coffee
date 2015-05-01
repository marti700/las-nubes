# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#=require GdriveActionHandler
$(window).load ->
  #deals with jquery file upload (see https://github.com/blueimp/jQuery-File-Upload/wiki/API)
  #$("#uploadForm").fileupload
  #  add:(e, data) ->
  #    data.context = $(tmpl("template-upload", data.files[0]))
  #    $("#uploadForm").append(data.context)
  #    data.submit()
  #  progress: (e,data) ->
  #    if data.context
  #      progress = parseInt(data.loaded / data.total *100, 10)
  #      data.context.find(".bar").css("width", progress + '%')

  #============================================================================================
  #********************************UPLOADS-DOWNLOADS-STATUS************************************
  #============================================================================================
  #controls the status bar that displays the upload download status to the user
  showStatus = (fileName, action)->
    progressBar = '<div class="progress">'+
        '<div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width: 40%">'+
            '<span class="sr-only">40% Complete (success)</span>'+
              '</div>'

    $('#table-container').animate {"height": "65%"}, "slow"
    $('#status-wrapper').animate {"height": "15%"}, "slow"
    $("#status-table").append "<tr> <td>#{fileName}</td> <td>#{action}</td> <td>#{progressBar}</td> <tr>"

  #============================================================================================
  #****************************UPLOADS-DOWNLOADS-STATUS-END************************************
  #============================================================================================


  #=============================================================================================
  #*******************************************UPLOADS*******************************************
  #=============================================================================================
  #Uploads content to google drive
  gdriveAction = (token)->
    gdriveHandler = new GdriveActionHandler(token)
    #gdriveHandler.authenticate()
  #upload content to dropbox
  dropboxAction = (access_token) ->
    dropboxHandler = new DropboxActionHandler(access_token)

  #Decides where to upload the file
  #the file will be uploaded to the cloud account with
  #more free space
  whereToUpload = (space_remaining) ->
    uploadTo = ''
    previousValue = 0
    for key, value of space_remaining
      if uploadTo == ''
        uploadTo = key
        previousValue = value
      else if value > previousValue
        uploadTo = key

    uploadTo


  #binds a change event on the input type file the triggers the upload process by selecting a file
  $('#files-explorer').bind 'change', ->
    file = document.getElementById('files-explorer').files[0]
    showStatus(file.name, "Uploading")
    $.ajax({
      url: "/files/upload"
      type: "GET"
      dataType: "json"
      success: (data, textStaus, jqXHRObject) ->
        cloudHandlers =  {dropbox: dropboxAction(data.dropbox_access_token), gdrive: gdriveAction(data.google_access_token)}
        #gdriveUploadAction(data.client_id, data.scopes)
        #cloudHandlers[whereToUpload({ gdrive: data.gdrive_remaining_space, dropbox: data.dropbox_remaining_space })]
        space_remaining = { gdrive: data.gdrive_remaining_space, dropbox: data.dropbox_remaining_space }
        cloudHandlers[(whereToUpload(space_remaining))].uploadFile(file)
    })
  #============================================================================================
  #*************************************UPLOADS END********************************************
  #============================================================================================

  #============================================================================================
  #****************************************FOLDERS*********************************************
  #============================================================================================

  #make the folder create form appear to the user
  $('#create-folder').click ->
    $('#folder-create').css 'display', 'block'
  #make the folder create form hidde when the table is clicked
  $('#files-table').click ->
    $('#folder-create').css 'display', 'none'
  #send data to the server for folder creation
  $('#folder-create-button').click ->
    currentPath = $('#currentpath').text()
    console.log currentPath
    data = {folder_name: $('#folder-name').val(), origin: currentPath}
    $.ajax({
      url: "/files/create_folder"
      type: "POST"
      data: data
      dataType: "script"
    });

#when a item of the table is dobule clicked if the item is a folder,
#folder content will be displayed, if item is a file it will be downloades
$(document).on "dblclick page:load", ".replaceable-row", ->
  data = {pathOrigin: this.getAttribute("origin").toString()}
  $('#currentpath').text(this.getAttribute("origin").toString())
  console.log $('#currentpath').text()
  if $(":nth-child(3)",this).text().indexOf("folder") != -1
    $.ajax({
      url: "/files/index"
      type: "GET"
      data: data
      dataType: "script"
    });
  else
    alert $(":nth-child(3)",this).text()
  #====================================================================================================
  #==========================================FOLDERS END***********************************************
  #===================================================================================================
