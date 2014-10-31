beforeEach ->
  $('body').append('<div id="jasmine_content"></div>')

afterEach ->
  $('#jasmine_content').remove()
