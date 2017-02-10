$(document).on 'turbolinks:load', ->
  $('#recap-datepicker').daterangepicker {
    locale:
      firstDay: 1
    alwaysShowCalendars: true
    autoUpdateInput: true
    startDate: moment().subtract(1, 'month').startOf('month')
    endDate: moment().endOf('month')
    parentEl: '#recap-datepicker'
    buttonClasses: 'btn btn-xs'
  }, (start, end, label) ->
	    $('#recap_range').val(start.format('D MMMM YYYY') +' - '+ end.format('D MMMM YYYY'))
	    $('#recap_start_date').val(start.format('YYYY-MM-DD'))
	    $('#recap_end_date').val(end.format('YYYY-MM-DD'))
	    return

	$('#recap-datepicker').on 'apply.daterangepicker', (event, picker) ->
		$('#recap_start_date').val(picker.startDate.format('YYYY-MM-DD'))
		$('#recap_end_date').val(picker.endDate.format('YYYY-MM-DD'))
		return

	$('#recap-datepicker').on 'cancel.daterangepicker', (event, picker) ->
		$('#recap_start_date').val(picker.startDate.format('YYYY-MM-DD'))
		$('#recap_end_date').val(picker.endDate.format('YYYY-MM-DD'))
		return