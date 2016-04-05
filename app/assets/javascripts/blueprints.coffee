# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).ready ->
  'use strict'
  # Init Theme Core    
  Core.init()
  # Init Demo JS    
  Demo.init()
  # Init Select2 - Basic Single
  $('.select2-single').select2()
  # Init Select2 - Basic Multiple
  $('.select2-multiple').select2
    placeholder: 'Select a state'
    allowClear: true
  # Init Select2 - Contextuals (via html classes)
  $('.select2-primary').select2()
  # select2 contextual - primary
  $('.select2-success').select2()
  # select2 contextual - success
  $('.select2-info').select2()
  # select2 contextual - info
  $('.select2-warning').select2()
  # select2 contextual - warning  

  # Init Boostrap Multiselects
  $('#multiselect1').multiselect();
  $('#multiselect2').multiselect({
    includeSelectAllOption: true
  });
  $('#multiselect3').multiselect();
  $('#multiselect4').multiselect({
    enableFiltering: true,
  });
  $('#multiselect5').multiselect({
    buttonClass: 'multiselect dropdown-toggle btn btn-default btn-primary'
  });
  $('#multiselect6').multiselect({
    buttonClass: 'multiselect dropdown-toggle btn btn-default btn-info'
  });
  $('#multiselect7').multiselect({
    buttonClass: 'multiselect dropdown-toggle btn btn-default btn-success'
  });
  $('#multiselect8').multiselect({
    buttonClass: 'multiselect dropdown-toggle btn btn-default btn-warning'
  });
  return