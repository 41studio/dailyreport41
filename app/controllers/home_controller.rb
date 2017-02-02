class HomeController < ApplicationController
  def index
    @projects = current_user.projects.latest.page(params[:page]).per(10)
  end
end
