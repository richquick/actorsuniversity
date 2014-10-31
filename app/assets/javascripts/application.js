// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery-1.9.1
//= require jquery-ui-1.10.3.custom
//= require jquery_ujs
//= require turbolinks
//= require jquery-fileupload
//= require chosen-jquery
//= require jquery.raty
//= require jquery-autocomplete
//= require hogan-2.0.0
//= require typeahead
//= require tag-it
//= require underscore.js
//= require jquery_nested_form
//= require list
//= require masonry.pkgd.js
//= require jquery.waitforimages
//= require jquery.fancybox
//= require highcharts
//= require highcharts-data
//= require highcharts-exporting
//= require 'rest_in_place'
//= require_tree .

onTurboLoad = function(){
  var loader = new FeatureSelector();
  loader.setup();
}

$(document).ready(onTurboLoad);
$(document).on('page:load', onTurboLoad);
$(document).bind('page:change', function(){ $.fancybox.init() });
