class @LineGraph
  convertDate: (d)->
    Date.UTC(d[0], d[1], d[2])

  setup: ->
    line_graph = $("#line_graph")
    return false  if line_graph.length is 0

    Highcharts.setOptions global:
      useUTC: false

    completion_dates = gon.lesson_completion.map (x)=>
      [@convertDate(x[0]), x[1]]

    completion_date_start = @convertDate(gon.lesson_completion_date_start)

    creation_dates = gon.lesson_creation.map (x)=>
      [@convertDate(x[0]), x[1]]


    creation_date_start = @convertDate(gon.lesson_creation_date_start)

    series = [
          {
            type: "line"
            name: "Lesson Completion"
            pointInterval: 24 * 3600
            pointStart: completion_date_start
            data: completion_dates
          },
          {
            type: "line"
            name: "Lesson Creation"
            pointInterval: (24 * 3600)
            pointStart: creation_date_start
            data: creation_dates
          }
    ]


    line_graph.highcharts
      series: series

      chart:
        type: 'spline'
        zoomType: "x"
        spacingRight: 20

      title:
        text: "Lesson completion/creation history"

      xAxis:
        type: 'datetime'

        dateTimeLabelFormats: # don't display the dummy year
          month: '%e. %b'
          year: '%b'
      yAxis:
        title:
          text: 'Number of lessons'
        min: 0

      tooltip:
        shared: true

      legend:
        enabled: true



