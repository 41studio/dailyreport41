class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects.all.page(params[:page]).per(30)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = current_user.projects.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show_email
    project = current_user.projects.find(params[:id])
    render json: {email_to: project.email_client, email_cc: project.email_cc, email_bcc: project.email_bcc}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = current_user.projects.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      check_emails
      params.require(:project).permit(:name, :description, :email_client, :email_project_manager, :client_name, :project_manager_name, :email_cc, :email_bcc)

    end

    def check_emails
      email_cc = params[:project][:email_cc].to_s.split(',').select{|email| Validator.is_email?(email)}
      params[:project][:email_cc] = email_cc.join(",")

      email_bcc = params[:project][:email_bcc].to_s.split(',').select{|email| Validator.is_email?(email)}
      params[:project][:email_bcc] = email_bcc.join(",")

      params
    end
end
