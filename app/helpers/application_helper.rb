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
    date.try(:strftime, '%d %B %Y')
  end
end
