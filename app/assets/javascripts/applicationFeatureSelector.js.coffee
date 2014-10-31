class @FeatureSelector
  testMode: ->
    window.location.pathname.match(/\/teaspoon/)

  setupKlasses: (klasses)->
    klasses.map (klass)->
      instance = new(klass)
      instance.setup()


  setup: ->
    return false if @testMode()

    $('.rest-in-place').restInPlace()

    @setupKlasses([Toggler, Lightbox, Accordion, Jigsaw, NavCounts,
      TextClipper, DatePicker, RatyLoader, Tagger])

    if @shouldLoadAssetUploader()
      @setupKlasses([Oembed, AssetUploader])

    try
      (new Typeahead).setup(gon.search_prepopulated_data)

    if @displayCharts()
      @setupKlasses([DashboardChart, LineGraph, FunnelGraph])

    if @shouldLoadChosen()
      instance = new ChosenLoader
      instance.setup()

  displayCharts: ->
    gon.user_type == "admin" &&
    @controller().match(/dashboard/)

  controller: ->
    $('body').data('controller')

  action: ->
    $('body').data('action')

  #We can disable things like chosen on iPad
  platform: ->
    #TECHDEBT - see https://github.com/garafu/jquery.depend
    'desktop'

  shouldLoadChosen: ->
    @platform() == "desktop"


  shouldLoadAssetUploader: ->
    @controller() == "admin/lessons" &&
      ((@action() == "new") || (@action() == "edit"))

