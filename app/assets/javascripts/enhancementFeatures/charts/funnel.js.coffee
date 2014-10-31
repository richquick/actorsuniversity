class @FunnelGraph
  setup: ->
    funnel_graph = $("#funnel_graph")
    return false  if funnel_graph.length is 0

    Highcharts.setOptions global:
      useUTC: false

    #TECHDEBT - move into CSS
    secondary_color_dark  = '#0671a0'
    secondary_color       = '#098bc4'
    secondary_color_light = '#08a4e9'

    primary_color_light = '#9ad751'
    primary_color       = '#86bb47'
    primary_color_dark  = '#719e3c'


    funnel_graph.highcharts
      colors: [
         secondary_color_dark,
         secondary_color_dark,
         secondary_color,
         secondary_color_light,

         primary_color_light,
         primary_color,
         primary_color_dark
      ]

      chart:
        type: 'funnel'
        marginRight: 100

      title:
        text: ''
        x: -50

      plotOptions:
        series:
          dataLabels:
            enabled: true
            format: '<b>{point.name}</b> ({point.y:,.0f})'
            color: 'black'
            softConnector: true

          neckWidth: '30%'
          neckHeight: '25%'

          # height: pixels or percent
          # width: pixels or percent
      legend:
        enabled: false

      series: [
        name: 'Completed lessons'
        data: gon.funnel_graph
      ]
