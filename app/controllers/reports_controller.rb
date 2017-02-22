class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:new, :edit, :create, :update]

  # GET /reports
  # GET /reports.json
  def index
    @reports = current_user.reports.includes(:project).order("created_at DESC").page(params[:page]).per(30)
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
   @body_template = @report.template
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new(reported_at: Time.zone.now, project_id: @project.try(:id))
    @report.email_to = @project.try(:email_client)
    @report.email_cc = @project.try(:email_cc_text)
    @report.email_bcc = @project.try(:email_bcc)
    @report.tasks.build(status: "completed")
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = current_user.reports.new(report_params)

    respond_to do |format|
      if @report.save
        send_report
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        send_report
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = current_user.reports.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:subject, :body, :email_to, :email_cc, :email_bcc, :reported_at, :note, :project_id, :resend, :work_hour, tasks_attributes: [:id, :title, :status, :user_id, :_destroy])
    end

    def set_projects
      @projects = current_user.projects
    end

    def send_report
      @report.send_async! if params[:commit].eql?("Save & Send")
    end

    def set_project
      @project = current_user.projects.find_by_slug(params[:project_id])
    end
end
