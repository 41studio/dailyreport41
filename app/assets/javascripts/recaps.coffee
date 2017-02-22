pickDate = (start = moment().weekday(1), end = moment().weekday(5)) ->
  $('#recap_range').val("#{start.format('D MMMM YYYY')} - #{end.format('D MMMM YYYY')}")
  $('#recap_start_date').val(start.format('YYYY-MM-DD'))
  $('#recap_end_date').val(end.format('YYYY-MM-DD'))
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
  pickDate()
  $('#recap_range').daterangepicker {
    locale:
      firstDay: 1
      format: 'DD/MM/YYYY'
      separator: '-'
    alwaysShowCalendars: false
    autoUpdateInput: false
    autoApply: true
    startDate: moment().weekday(1)
    endDate: moment().weekday(5)
    parentEl: '#recap-datepicker'
    buttonClasses: 'btn btn-xs'
  }, (start, end, label) ->
    pickDate(start, end)
    return
  return
