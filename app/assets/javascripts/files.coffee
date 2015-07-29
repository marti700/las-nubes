# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#=require GdriveActionHandler
$(window).on 'load page:load', ->
  firstTime = true
  # insert elements the first time the page loads 
  firstLoad = ->
    if gon.files != undefined
        console.log gon.files
        #appends the elements to the files table
        for element, contents of gon.files['root']
          if contents.type == 'folder'
            #change spaces with '-'
            #/[^\/]*.$/ takes the string after the last '/' which is the foder name
            childrens = contents.original_path.replace(/\s/g,'-')
            #puts elements into the tree view
            treeViewNode = "<li class='tree-view-node' childrens = #{contents.origin}:#{childrens}>"+
                           "#{contents.name}</li>"
            $('#tree').append treeViewNode

          else
            childrens = null
          
          #puts elements into the files table
          tableRow = "<tr class='ft-row' childrens = #{contents.origin}:#{childrens}>" +
                      "<td> #{contents.name}</td>"+
                      "<td> #{contents.size}</td>"+
                      "<td> #{contents.type}</td></tr>"
          $('#files-table').append tableRow
        
             
  #refresh elemens of the files table
  if firstTime
    firstLoad()
    firstTime = false
    #tree = new TreeView('#tree-view')
    console.log $('#tree-view > ul > li')

  #============================================================================================
  #************************************ Listing Files *****************************************
  #============================================================================================

  if gon.files != undefined
    console.log gon.files
    #appends the elements to the files table
    appendTableElements = (folder) ->
        for element, contents of gon.files[folder]
          if contents.type == 'folder'
            #change spaces with '-'
            childrens = contents.original_path.replace(/\s/g,'-')
          else
            childrens = ''
          
          tableRow = "<tr class='ft-row' childrens = #{contents.origin}:#{childrens}>" +
                        "<td> #{contents.name}</td>"+
                        "<td> #{contents.size}</td>"+
                        "<td> #{contents.type}</td></tr>"
          $('#files-table').append tableRow

    #remove all elemets from the files table
    removeTableElements = ->
      $('.ft-row').empty()

    
    $('#files-table').on 'dblclick','.ft-row', ->
      if $(":nth-child(3)",this).text().indexOf("folder") != -1
        $('#currentpath').text $(this).attr('childrens') #keeps track of the current path
        removeTableElements()
        #the childrens has the format cloudHandler:path the [^:]*.$ regexp
        #will take the path or the childrens attribute string.
        childs = $(this).attr('childrens').match(/[^:]*.$/)[0]
        appendTableElements childs.replace(/-/g,' ')

      else
        console.log 'Downloading'
  
  #============================================================================================
  #********************************** Listing Files End ***************************************
  #============================================================================================
  
  #============================================================================================
  #************************************** Tree View *******************************************
  #============================================================================================
  #shows folders contents (just folders)
  $('#tree').on 'click','.tree-view-node', (event)->
    if $(this).children('ul').length > 0 #if there is an ul don't do anything
      $(this).children('ul').toggleClass 'expanded closed'
      console.log $(this)
      console.log $(this).children 'ul'
      event.stopPropagation()
      return -1
    nodeChildren = $("<ul class='master-children-ul expanded'></ul>")
    childs = $(this).attr('childrens').match(/[^:]*.$/)[0]
    for element, contents  of gon.files[childs.replace(/-/g,' ')]
      if contents.type == 'folder'
        childrens = contents.original_path.replace(/\s/g, '-')
        newChilds = "<li class='tree-view-node' childrens=#{contents.origin}:#{childrens}>"+
                    "#{contents.name}</li>"
        nodeChildren.append newChilds
    
    $(this).append nodeChildren if nodeChildren.children('li').length > 0
    #this event handler were being called twice which lead to repeated child nodes
    event.stopPropagation() #prevents this event handler for being called twice
  
  #Update files table elements (show folder's files in the file table)
  $('#tree').on 'dblclick', '.tree-view-node', (event)->
    $('#currentpath').text $(this).attr('childrens') #keeps track of the current path
    removeTableElements()
    #the childrens has the format cloudHandler:path the [^:]*.$ regexp
    #will take the path or the childrens attribute string.
    childs = $(this).attr('childrens').match(/[^:]*.$/)[0]
    appendTableElements childs.replace(/-/g,' ')

    #this event handler were being called twice which lead to repeated child nodes
    event.stopPropagation() #prevents this event handler for being called twice

  
  #============================================================================================
  #*********************************** Tree View End ******************************************
  #============================================================================================

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
  #controls the status bar that displays the upload status to the user
  showStatus = (fileName, action)->
    progressBar = '<div class="progress">'+
        '<div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%">'+
            '0%'+
              '</div></div>'

    $('#table-container').animate {"height": "65%"}, "slow"
    $('#status-wrapper').animate {"height": "15%"}, "slow"
    $("#status-table").append "<tr> <td>#{fileName}</td> <td>#{action}</td> <td>#{progressBar}</td> </tr>"
    return [$('#status-table tr:last td:nth-child(2)'), $('#status-table tr:last td:last div:last')]

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
  whereToUpload = (path, space_remaining) ->
    uploadAddress = {}
    if path == '/'
      uploadTo = ''
      previousValue = 0
      for key, value of space_remaining
        if uploadTo == ''
          uploadTo = key
          previousValue = value
        else if value > previousValue
          uploadTo = key
      uploadAddress = {cloudDrive: uploadTo, path: '/'}
    else
      uploadAddress = {cloudDrive: path.match(/^(gdrive|dropbox)/)[0], path: path.match(/[^:]*.$/)[0].replace(/-/, ' ')}

    uploadAddress

  #binds a change event on the input type file the triggers the upload process by selecting a file
  $('#files-explorer').bind 'change', ->
    file = document.getElementById('files-explorer').files[0]
    updateStatus = showStatus(file.name, "Uploading")
    $.ajax({
      url: "/files/upload"
      type: "GET"
      dataType: "json"
      success: (data, textStaus, jqXHRObject) ->
        cloudHandlers =  {dropbox: dropboxAction(data.dropbox_access_token), gdrive: gdriveAction(data.google_access_token)}
        #takes the path where the file will be uploaded
        
        #if $('#currentpath').text() == '/'
        #  uploadPath = '/'
        #else
        #  uploadPath = $('#currentpath').text().replace(/-/g,' ')

        space_remaining = { gdrive: data.gdrive_remaining_space, dropbox: data.dropbox_remaining_space }
        #uploads the file to the correct cloud drive, where the file is uploaded by default depends
        #of the cloud account free space if the file is placed in root.
        uploadTo = whereToUpload($('#currentpath').text(), space_remaining)
        cloudHandlers[uploadTo.cloudDrive].uploadFile(file, uploadTo.path, updateStatus[0], updateStatus[1], $("#files-table"))
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
    data = {folder_name: $('#folder-name').val(), origin: currentPath}
    $.ajax({
      url: "/files/create_folder"
      type: "POST"
      data: data
      dataType: "script"
    })

#when a item of the table is dobule clicked if the item is a folder,
#folder content will be displayed, if item is a file it will be downloaded
#$(document).on "dblclick page:load", "#files-table", ->
#  data = {pathOrigin: this.getAttribute("origin").toString()}
#  $('#currentpath').text(this.getAttribute("origin").toString())
#  console.log $('#currentpath').text()
#  if $(":nth-child(3)",this).text().indexOf("folder") != -1
#    console.log $(this)
#    $.ajax({
#      url: "/files/index"
#      type: "GET"
#      data: data
#      dataType: "script"
#    })
#  else
#    alert $(":nth-child(3)",this).text()
  #====================================================================================================
  #==========================================FOLDERS END***********************************************
  #===================================================================================================
