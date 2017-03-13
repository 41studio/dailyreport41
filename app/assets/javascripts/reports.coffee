# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

selectProject = ->
  $('select#report_project_id').select2
    ajax:
      url: '/projects'
      dataType: 'json'
      delay: 250
      data: (params) ->
        {
          q: params.term
          page: params.page
        }
      processResults: (data, params) ->
        params.page = params.page or 1
        {
          results: data.projects
          pagination:
            more: params.page * 30 < data.total_count
        }
      cache: true
    minimumInputLength: 0

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

addTopBottomBorderToInput = (selector) ->
  $(selector).parent().closest('.task-list').css('border-top', '1px solid silver').css('border-bottom', '1px solid silver')

styleTaskList = ->
  $('input.task-title').focus()
  addTopBottomBorderToInput('input.task-title')
  $('body').on 'focus', 'input.task-title', ->
    $('.task-list').css('border', 'none')
    addTopBottomBorderToInput(@)
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
        prevTasks = nestedField.prevAll()
        unless nestedField.find('input.task-title').val()
          prevTasks.closest('.nested-fields').last().find('input.task-title').focus()
          nestedField.remove() if prevTasks.length > 0
      # delete
      when 46
        nextTasks = nestedField.nextAll()
        window.nextInputTask = nextTasks.closest('.nested-fields').first().find('input.task-title')
        if nextInputTask.val()
          nextInputTask.focus()
        else
          $(@).focus()
          if $(@).val() == ""
            nestedField.remove() if nextTasks.length > 1
            nextInputTask.focus() if nextInputTask.length > 0
          else if $(@).get(0).selectionStart == $(@).val().length and nextInputTask.val() == ""
            nextInputTask.parent().closest('.nested-fields').remove()
            nextInputTask.focus() if nextInputTask.length > 0
    return

  $('body').on 'cocoon:after-insert', '#tasks', (e, insertedItem) ->
    prevItemStatus = insertedItem.prevAll().closest('.nested-fields').last().find('input[type="checkbox"]')
    isPrevItemChecked = if prevItemStatus.length == 0 then true else prevItemStatus.is(':checked')
    insertedItem.find('input[type="checkbox"]').prop('checked', isPrevItemChecked)
    insertedItem.find('input.task-title').focus()
    return
  return

disbaleSubmitOnEnter = ->
  $('.form-report').on 'keypress', (e) ->
    return false if e.keyCode == 13

pickDate = (startDate, endDate) ->
  $('#report_range').val("#{startDate.format('D MMMM YYYY')} - #{endDate.format('D MMMM YYYY')}")
  $('#report_start_date').val(startDate.format('YYYYMMDD'))
  $('#report_end_date').val(endDate.format('YYYYMMDD'))
  return

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

    if $('#report_start_date').val() and $('#report_end_date').val()
      startDate = moment($('#report_start_date').val())
      endDate = moment($('#report_end_date').val())
    else
      startDate = moment().subtract(1, 'week').weekday(1)
      endDate = moment().subtract(1, 'week').weekday(7)

    pickDate(startDate, endDate)
    $('#report_range').daterangepicker {
      locale:
        firstDay: 1
        format: 'DD-MM-YYYY'
        separator: '-'
      alwaysShowCalendars: false
      autoUpdateInput: false
      autoApply: true
      startDate: startDate
      endDate: endDate
      parentEl: '#report-daterange-picker'
      buttonClasses: 'btn btn-xs'
    }, (startDate, endDate, label) ->
      pickDate(startDate, endDate)
      $('.filter-range-report').submit()
      return
    return


  return

