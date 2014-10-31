# TECHDEBT
# This is probably some of the riskiest/potentially most flaky code in the project
# Basically hacked in from bits and pieces so we can do async drag and drop stuff
# for file upload
# See here for some examples: #https://github.com/blueimp/jQuery-File-Upload/wiki#ruby
# Would be really good to improve this code, get some decent jasmine tests around it,
# and also get it directly uploading to S3
class @AssetUploader
  setup: =>
    @setupJqueryUploader()
    fileUpload = $("#fileupload").data("blueimpFileupload")

    @displayer = new FileDisplayer(fileUpload)

    @toggleDefaultUploadFunctionality()
    @fetchThumbnail()

  setupJqueryUploader: =>
    $("#fileupload").fileupload
      maxNumberOfFiles: 1
      autoUpload: true
      completed: @success
      error: @failure

  success: (event, response)=>
    file = JSON.parse(response.xhr().responseText)
    @displayer.displaySuccess(file)

  failure: (event, response)=>
    errors = JSON.parse(event.responseText).files[0].error
    @displayer.setError(errors[0])

  fetchThumbnail: =>
    action  = "/admin/resource_file_from/" + $('#lesson_token').val()

    $.getJSON action, (files) =>
      @displayer.displaySuccess(files)

  toggleDefaultUploadFunctionality: ->
    uploadBox = $(".normal.fileupload")

    uploadBox.click ->
      $(@).toggleClass('default')

class FileDisplayer
  constructor: (fileUpload) ->
    @fileUpload = fileUpload

  setError: (message)->
    $('#fileupload_errors').html(message)

  displaySuccess: (file)=>
    if file && file.size > 0
      @setError('')

      @fileUpload._adjustMaxNumberOfFiles -1
      container = $(".fileupload-content .files")
      template = @fileUpload._renderDownload([file]).appendTo(container)
      $('#filename').html(file.filename)
      $('#filesize').html(@humanize file.size)

      # Force reflow:
      @fileUpload._reflow = @fileUpload._transition and template.length and template[0].offsetWidth
      template.addClass "in"
      $("#loading").remove()

      $('form.hide').toggleClass('hide')
      $('#fileupload').hide()
      $('*[data-form-section="pasteALink"]').hide()


  humanize: (bytes) ->
    return bytes + " B" if bytes < 1000

    unit = 1000

    exp = Math.floor(Math.log(bytes) / Math.log(unit))
    post = ' ' + "kMGTPE".charAt(exp - 1) + 'B'
    (bytes / Math.pow(unit, exp)).toFixed(1) + post
