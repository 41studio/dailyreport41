pickDate = (start = moment().startOf('month'), end = moment().endOf('month')) ->
  $('#recap_range').val("#{start.format('D MMMM YYYY')} - #{end.format('D MMMM YYYY')}")
  $('#recap_start_date').val(start.format('YYYY-MM-DD'))
  $('#recap_end_date').val(end.format('YYYY-MM-DD'))
  return

$(document).on 'turbolinks:load', ->
  pickDate()
  $('#recap_range').daterangepicker {
    locale:
      firstDay: 1
      format: 'DD/MM/YYYY'
      separator: '-'
    alwaysShowCalendars: false
    autoUpdateInput: false
    autoApply: true
    startDate: moment().startOf('month')
    endDate: moment().endOf('month')
    parentEl: '#recap-datepicker'
    buttonClasses: 'btn btn-xs'
  }, (start, end, label) ->
    pickDate(start, end)
    return
