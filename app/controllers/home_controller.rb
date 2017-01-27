class HomeController < ApplicationController
  def index
    @project_count = current_user.projects.size
    @report_count = current_user.reports.size
  end
end
