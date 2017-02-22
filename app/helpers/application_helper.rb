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

  def round_work_hour(work_hour)
    work_hour % 1 == 0 ? work_hour.to_i : work_hour.to_f
  end

  def date_and_work_hour_text(date, work_hour)
    text = formated_date(date)
    text += " <b>(#{pluralize(round_work_hour(work_hour), 'hr')})</b>"
    text.html_safe
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

  def is_active_recaps?
    "active" if controller_name.eql?('recaps')
  end

  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:time, time.to_s, options.merge(datetime: time.iso8601)) if time
  end
end
