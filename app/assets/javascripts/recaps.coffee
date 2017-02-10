$(document).on 'turbolinks:load', ->
  $('.recap-date').pickadate
    firstDay: 1
    format: 'd mmmm yyyy'
