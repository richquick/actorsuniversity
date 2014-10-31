class @Tagger
  setup: =>
    @hideSubmit()
    $(".taggable.no.ajax").tagit()

    $(".taggable.with.ajax").tagit
      afterTagAdded: (event, ui)=>
        @processEvent(event)

      afterTagRemoved: (event, ui)=>
        @process(event)


  hideSubmit: ->
    $('.taggable.with.ajax').closest('form').find('button').hide()

  processEvent: (event)->
    #TECHDEBT massive hack, works OK for successful responses
    #but also gets triggered during page load for each tag added
    $(event.target).closest('form').submit()


