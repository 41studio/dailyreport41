pickDate = (startDate, endDate) ->
  $('#recap_range').val("#{startDate.format('D MMMM YYYY')} - #{endDate.format('D MMMM YYYY')}")
  $('#recap_start_date').val(startDate.format('YYYYMMDD'))
  $('#recap_end_date').val(endDate.format('YYYYMMDD'))
  $('.btn-recap').each ->
    params =
      project_id: $(@).data('project')
      user_id: $(@).data('user')
      start_date: $('#recap_start_date').val()
      end_date: $('#recap_end_date').val()
    $(@).attr('href', Routes.view_recaps_path(params))
  return

$(document).on 'turbolinks:load', ->
  $('time.timeago').timeago()
  if $('#recap_start_date').val() and $('#recap_end_date').val()
    startDate = moment($('#recap_start_date').val())
    endDate = moment($('#recap_end_date').val())
  else
    startDate = moment().subtract(1, 'week').weekday(1)
    endDate = moment().subtract(1, 'week').weekday(5)

  pickDate(startDate, endDate)
  $('#recap_range').daterangepicker {
    locale:
      firstDay: 1
      format: 'DD-MM-YYYY'
      separator: '-'
    alwaysShowCalendars: false
    autoUpdateInput: false
    autoApply: true
    startDate: startDate
    endDate: endDate
    parentEl: '#recap-datepicker'
    buttonClasses: 'btn btn-xs'
  }, (startDate, endDate, label) ->
    pickDate(startDate, endDate)
    $('.filter-range-recap').submit()
    return
  return
