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
  
  #=============================================================================================
  #*******************************************UPLOADS*******************************************
  #=============================================================================================
  #Uploads content to google drive
  gdriveUploadAction = (client_id, scopes)->
    gdriveHandler = new GdriveActionHandler(client_id, scopes)
    gdriveHandler.authenticate()
    gdriveHandler.uploadFile()


  #binds a change event on the input type file the triggers the upload process by selecting a file
  $('#files-explorer').bind 'change', ->
    $.ajax({
      url: "/files/upload"
      type: "GET"
      dataType: "json"
      success: (data, textStaus, jqXHRObject) ->
        console.log data
        gdriveUploadAction(data.client_id, data.scopes)
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
