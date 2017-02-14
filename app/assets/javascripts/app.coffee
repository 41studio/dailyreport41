$(document).on 'turbolinks:load', ->
  $('.sidebar-toggle').bind 'click', (e) ->
    $('#sidebar').toggleClass 'active'
    $('.app-container').toggleClass '__sidebar'
    return
  $('.navbar-toggle').bind 'click', (e) ->
    $('#navbar').toggleClass 'active'
    $('.app-container').toggleClass '__navbar'
    return
