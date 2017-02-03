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
          $('.tagging-email').tagit()
          $('input#report_email_to').val(data.email_to)
          $('input#report_email_cc').val(data.email_cc)
          $('input#report_email_bcc').val(data.email_bcc)
          $('.tagging-email').tagit()
          return
    else
      $('.tagging-email').tagit('removeAll')
      $('input#report_email_to').val('')
      $('input#report_email_cc').val('')
      $('input#report_email_bcc').val('')
    return

  return

toggleEmailReceiver = ->
  $('#toggle-email-receiver').on 'click', ->
    $('#email-receiver').slideToggle()

pickerDate = ->
  $('#report_reported_at').pickadate
    firstDay: 1
    format: 'd mmmm yyyy'
    min: -1
    max: true
  return

markdownEditor = ->
  if $('#text-editor').length
    simplemde = new SimpleMDE element: $('#text-editor')[0], hideIcons: ['side-by-side', 'fullscreen'], spellChecker: false
  return

taggingEmail = ->
  $('.tagging-email').tagit()
  return

styleTaskList = ->
  $('body').on 'focus', 'input.task-title', ->
    console.log('task')
    window.taskTitle = $(@)
    $('.task-list').css('border', 'none')
    $(@).parent().closest('.task-list').css('border-top', '1px solid silver').css('border-bottom', '1px solid silver')
    $(@).parent().closest('.task-list').next().show()
    $(@).on 'keypress', (e) ->
      window.addField = $('a.add_fields') if e.keyCode == 13
    return

  # TODO
  # show hide button remove on focus and hover the task
  # $('body').on 'blur', 'input.task-title', ->
  #   $('.task-list').css('border', 'none')
  #   $('.task-remove').hide()
  #   return

  # $('.task-list').on 'hover', ->
  #   window.taskList = $(@)
  #   console.log('hover')
  #   $(@).parent().closest('.task-list').next().show()
  #   return
  return

disbaleSubmitOnEnter = ->
  $('.form-report').on 'keypress', (e) ->
    return false if e.keyCode == 13

$(document).on 'turbolinks:load', ->
  selectProject()
  toggleEmailReceiver()
  pickerDate()
  markdownEditor()
  taggingEmail()
  styleTaskList()
  disbaleSubmitOnEnter()
  # $('body').on 'cocoon:after-insert', '#tasks', (e, taskItem) ->
  #   window.taskItem = taskItem
  #   console.log taskItem
  return


