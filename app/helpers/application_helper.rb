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

  def is_active_dashboard?
    "active" if current_page?('/')
  end

  def is_active_projects?
    "active" if controller_name.eql?('projects')
  end

  def is_active_reports?
    "active" if controller_name.eql?('reports')
  end
end
