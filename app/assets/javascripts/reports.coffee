# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

selectProject = ->
  $('select#report_project_id').select2();
  $('select#report_project_id').on 'select2:select', ->
    # console.log $(@).val()
    projectId = $(@).val()
    if parseInt(projectId) > 0
      $.ajax
        url: Routes.show_email_project_path(projectId)
        method: 'GET'
        dataType: 'json'
        success: (data) ->
          # console.log data
          $('input#report_email_to').tokenfield('setTokens', data.email_to)
          $('input#report_email_cc').tokenfield('setTokens', data.email_cc)
          $('input#report_email_bcc').tokenfield('setTokens', data.email_bcc)
          return
    else
      $('input#report_email_to').val('')
      $('input#report_email_cc').val('')
      $('input#report_email_bcc').val('')
    return

  return

toggleEmailReceiver = ->
  $('#toggle-email-receiver').on 'click', ->
    $('#email-receiver').slideToggle()

pickerDate = ->
  $('#report_reported_at').pickadate format: "d mmmm yyyy"
  return

markdownEditor = ->
  if $("#text-editor").length
    simplemde = new SimpleMDE element: $("#text-editor")[0], hideIcons: ["side-by-side", "fullscreen"], spellChecker: false
  return

taggingEmail = ->
  $('.tagging-email').on('tokenfield:createtoken', (e) ->
    data = e.attrs.value.split('|')
    e.attrs.value = data[1] or data[0]
    e.attrs.label = if data[1] then data[0] + ' (' + data[1] + ')' else data[0]
    return
  ).on('tokenfield:createdtoken', (e) ->
    # Über-simplistic e-mail validation
    re = /\S+@\S+\.\S+/
    valid = re.test(e.attrs.value)
    if !valid
      $(e.relatedTarget).addClass 'invalid'
    return
  ).on('tokenfield:edittoken', (e) ->
    if e.attrs.label != e.attrs.value
      label = e.attrs.label.split(' (')
      e.attrs.value = label[0] + '|' + e.attrs.value
    return
  ).tokenfield()

  return

$(document).on 'turbolinks:load', ->
  selectProject()
  toggleEmailReceiver()
  pickerDate()
  markdownEditor()
  taggingEmail()
  return
