#=require 'typeAhead'
describe Typeahead, ->

  beforeEach ->
    courseResults = [
        {"title":"Tuna", "file_type":"link", "value":"typeahead.js"}
        {"title":"Introduction to youtube","file_type":"link","value":"Introduction to youtube"},
        {"title":"Cats","file_type":"link", "value":"Cats"},
      ]

    lessonResults = [
      {"name":"Lesson","local":[
        {"title":"Byoudouin","file_type":"jpg","value":"Byoudouin"},
        {"title":"京橋","file_type":"pdf"}
      ]}
    ]

    results = [
      {
        name: 'Lessons',
        locals: lessonResults,
        header: '<h3 class="lessons">Lessons</h3>'
        template: '<a class="{{file_type}} href="google.com">{{title}}</a>"'
        engine: Hogan
      },
      {
        name: 'Courses',
        locals: courseResults,
        header: '<h3 class="courses">Courses</h3>'
        template: '<a class="{{file_type}} href="google.com">{{title}}</a>"'
        engine: Hogan
      }
    ]

    jasmine.Ajax.useMock()

    @typeahead = new Typeahead
    $('#jasmine_content').html("<input class='typeahead'/>")

    @typeahead.setup(results)

  xit "prepopulates the dropdown", =>
    fillIn = (selector, sequence)->
      $(selector).simulate("key-sequence", {sequence: sequence.with});

    fillIn('.typeahead', with: "Byou")
    expect($('.tt-dataset-Lessons a')).toHaveClass 'jpg'

