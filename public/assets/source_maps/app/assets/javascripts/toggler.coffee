class @Toggler
  setup: ->
    $('.lessons_toggle_link').click (e)->
      e.preventDefault()
      $('.lesson_list_column').toggle()
      $('.dashboard_column').toggle()

    $('.tab_links li a').click (e)->
      e.preventDefault()
      $('.tabs .tab_links li').removeClass('active')
      $(this).parent().addClass('active')
      $('.tab_content').hide()
      $($(this).attr('href')).show()
