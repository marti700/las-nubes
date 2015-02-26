# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready -> 
  #deals with jquery file upload (see https://github.com/blueimp/jQuery-File-Upload/wiki/API)
  $("#uploadForm").fileupload
    add:(e, data) ->
      data.context = $(tmpl("template-upload", data.files[0]))
      $("#uploadForm").append(data.context)
      data.submit()
    progress: (e,data) ->
      if data.context
        progress = parseInt(data.loaded / data.total *100, 10)
        data.context.find(".bar").css("width", progress + '%')
#when a item is dobule clicked
$(document).on "dblclick page:load", ".replaceable-row", ->
  data = {pathOrigin: this.getAttribute("origin").toString()}
  if $(":nth-child(3)",this).text().indexOf("folder") != -1
    $.ajax({
      url: "/files/index"
      type: "GET"
      data: data 
      dataType: "script"
    });
  else
    alert $(":nth-child(3)",this).text()
