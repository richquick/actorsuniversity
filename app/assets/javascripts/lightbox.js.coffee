class @Lightbox
  setup: =>
    selector = '.fancybox'

    options = @defaults()
    options.type= 'iframe'

    $(selector + '.iframe').fancybox options

    options = @defaults()
    options.type= 'swf'
    $(selector + '.video').fancybox options

    options = @defaults()
    options.type= 'image'
    options.padding = 0
    $(selector + '.image').fancybox options

    options = @defaults()
    options.type = 'inline'

    $(selector + '.inline').fancybox options

    @setupClosingFromWithinIframe()

  defaults: ->
    width: '75%'
    height: '75%'
    autoScale: true
    transitionIn = 'elastic'
    transitionOut: 'elastic'

  setupClosingFromWithinIframe: ->
    $('.iframe_closer').on 'click', ->
      parent.$.fancybox.close();
