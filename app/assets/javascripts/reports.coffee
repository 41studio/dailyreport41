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
        dataType: 'script'
    else
      $('.tagging-email').tagit('removeAll')
      $('input#report_email_to').val('')
      $('input#report_email_cc').val('')
      $('input#report_email_bcc').val('')
    return

  return

toggleEmailRecipients = ->
  $('#toggle-email-recipients').on 'click', ->
    $('#js-email-recipients').slideToggle()

pickerDate = ->
  $('#report-datepicker').daterangepicker {
    singleDatePicker: true
    locale:
      format: 'YYYY-MM-DD HH:mm:ss'
      firstDay: 1
    minDate: moment().subtract(2, 'days')
    maxDate: moment()
    parentEl: '#report-datepicker'
  }, (start, end, label) ->
    $('#report_reported_date').val(start.format('D MMMM YYYY'))
    $('#report_reported_at').val(start.format('YYYY-MM-DD HH:mm:ss'))
    return
  return

markdownEditor = ->
  if $('#text-editor').length
    simplemde = new SimpleMDE element: $('#text-editor')[0], hideIcons: ['side-by-side', 'fullscreen'], spellChecker: false
  return

taggingEmail = ->
  $('.tagging-email').tagit()
  return

styleTaskList = ->
  $('input.task-title').focus()

  $('body').on 'focus', 'input.task-title', ->
    $('.task-list').css('border', 'none')
    $(@).parent().closest('.task-list').css('border-top', '1px solid silver').css('border-bottom', '1px solid silver')
    $(@).parent().closest('.task-list').next().show()
    return

  $('body').on 'keyup', 'input.task-title', (e) ->
    # console.log e.keyCode
    nestedField = $(@).parent().closest('.nested-fields')
    switch e.keyCode
      # enter
      when 13
        date = new Date
        template = $('a.add_fields').data('association-insertion-template')
        new_task = template.replace(/new_tasks/g, date.getTime())
        newItem  = $(new_task).insertBefore('#add-task')
        $(@).parent().closest('.nested-fields').nextAll().first().find('input.task-title').focus()

        # set checked based previous item
        isItemChecked = nestedField.find('input[type="checkbox"]').is(':checked')
        newItem.find('input[type="checkbox"]').prop('checked', isItemChecked)
      # down
      when 40
        element = nestedField.nextAll().closest('.nested-fields').first().find('input.task-title').get(0)
        if element
          valueLength = element.value.length
          if valueLength > 0
            element.selectionStart = valueLength
            element.selectionEnd = valueLength
          element.focus()
      # up
      when 38
        element = nestedField.prevAll().closest('.nested-fields').last().find('input.task-title').get(0)
        if element
          element.selectionStart = 0
          element.selectionEnd = 0
          element.focus()
      # backspace
      when 8
        unless nestedField.find('input.task-title').val()
          nestedField.prevAll().closest('.nested-fields').last().find('input.task-title').focus()
          nestedField.remove()
    return

  $('body').on 'cocoon:after-insert', '#tasks', (e, insertedItem) ->
    isPrevItemChecked = insertedItem.prevAll().closest('.nested-fields').last().find('input[type="checkbox"]').is(':checked')
    insertedItem.find('input[type="checkbox"]').prop('checked', isPrevItemChecked)
    return
  return

disbaleSubmitOnEnter = ->
  $('.form-report').on 'keypress', (e) ->
    return false if e.keyCode == 13

isLoaded = false
$(document).on 'turbolinks:load', ->
  unless isLoaded
    selectProject()
    toggleEmailRecipients()
    pickerDate()
    markdownEditor()
    taggingEmail()
    styleTaskList()
    disbaleSubmitOnEnter()
  return

