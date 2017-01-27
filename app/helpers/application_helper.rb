module ApplicationHelper

  def formated_date(date)
    if date.is_a?(Time)
      date.try(:strftime, '%d/%m/%Y %H:%M')
    else
      date.try(:strftime, '%d/%m/%Y')
    end
  end
end
