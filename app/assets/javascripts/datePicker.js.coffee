class @DatePicker
  setup: ->
    $.datepicker.setDefaults( $.datepicker.regional[ "en-GB" ] )

    $(".datepicker").datepicker()

    $( ".datepicker" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
