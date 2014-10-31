class @Oembed
  setup: ->
    @input = $('*[data-form-section="pasteALink"] input')
    @preview = $('*[data-form-section="videoPreview"]')

    url = @input.val()

    @update(url) if url.length > 0

    @input.blur (e)=> @update(url = e.currentTarget.value)

  update: (url)->
    $.get "/oembed?url=" + encodeURIComponent(url), @callback


  callback: (response)=>
    if response.thumbnail_url
      thumbnail = response.thumbnail_url
      title = "<h2 class='video_title'>" + response.title + "</h2>"
      imageTag = "<img class='video_thumbnail' src='" + thumbnail + "'/>"
      @preview.html("<div class='video_preview'>" + imageTag + title + "</div>")

