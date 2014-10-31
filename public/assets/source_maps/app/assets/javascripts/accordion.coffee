class @Accordion
  setup: ->
    $('.accordion .expander').click (e)->
      e.preventDefault()
      $(this).closest('.item').toggleClass('on')


