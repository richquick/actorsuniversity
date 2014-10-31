class @DashboardChart
  setup: ->
    @readValuesFromDom()

    Highcharts.setOptions
      global:
        useUTC: false
      chart:
        backgroundColor: ['white']
        #  linearGradient: [500, 500, 500, 500],
        #  stops: [
        #    [0, 'rgb(8, 164, 233)'],
        #    [1, 'rgb(134 187 71)'] ]
        borderWidth: 0,
        plotBackgroundColor: 'rgba(255, 255, 255, .9)',
        plotShadow: false,
        plotBorderWidth: 0


    # Register a parser for the American date format used by Google
    Highcharts.Data::dateFormats["m/d/Y"] =
      regex: "^([0-9]{1,2})/([0-9]{1,2})/([0-9]{2})$"
      parser: (match) ->
        Date.UTC +("20" + match[3]), match[1] - 1, +match[2]

    pie = new Pie
    $("#pie_chart").highcharts pie.chartOptions(gon.piechart_data)


  #This exists so we can style the graph without touching any
  #javascript
  readValuesFromDom: =>

