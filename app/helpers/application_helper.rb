module ApplicationHelper
  def navbar_title
    if current_page?('/')
      "Dashboard"
    elsif current_page?('/profile')
      "Profile"
    else
      controller_name.titleize
    end
  end

  def formated_date(date)
    if date.is_a?(Time)
      date.try(:strftime, '%d/%m/%Y %H:%M')
    else
      date.try(:strftime, '%d/%m/%Y')
    end
  end
end
