# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

selectProject = ->
  $('select#report_project_id').on 'change', ->
    # console.log $(@).val()
    projectId = $(@).val()
    if parseInt(projectId) > 0
      $.ajax
        url: Routes.show_email_project_path(projectId)
        method: 'GET'
        dataType: 'json'
        success: (data) ->
          # console.log data
          $('input#report_email_to').val(data.email_to)
          $('input#report_email_cc').val(data.email_cc)
          $('input#report_email_bcc').val(data.email_bcc)
          return
    return
  return

selectProject()
