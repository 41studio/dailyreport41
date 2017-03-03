module DateRange
  extend ActiveSupport::Concern

  def date_range
    if params.key?(:start_date) and params.key?(:end_date)
      date_to_range(params[:start_date], params[:end_date])
    else
      current_date = Time.zone.now
      date_to_range(current_date.beginning_of_week.strftime("%Y%m%d"), current_date.end_of_week.strftime("%Y%m%d"))
    end
  end

  private
    def date_to_range(start_date, end_date)
      if start_date =~ /T00:00:00/ || end_date =~ /T00:00:00/
        start_date..end_date
      else
        start_date.concat('T00:00:00')..end_date.concat('T23:59:59')
      end
    end
end
