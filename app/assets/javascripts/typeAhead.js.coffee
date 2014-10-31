class @Typeahead
  setup: (results)->
    results = results.map (result)-> result.engine = Hogan; result
    $('.typeahead').typeahead(results)
