class RecapsController < ApplicationController
  before_action :set_recap, only: [:show, :edit, :update, :destroy]

  # GET /recaps
  # GET /recaps.json
  def index
    @projects = Project.with_users.page(params[:page]).per(30)
    respond_to do |format|
      format.html
      format.json do
        @reports = Report.select(:id, :reported_at, :work_hour).includes(:tasks).where(project_id: params[:project_id], user_id: params[:user_id], reported_at: params[:start_date]..params[:end_date]).group("reports.id")
        project = Project.with_users.find_by(id: params[:project_id], user_id: params[:user_id])
        start_date = Date.parse(params[:start_date]).strftime("%B #{Date.parse(params[:start_date]).day.ordinalize}, %Y") rescue nil
        end_date = Date.parse(params[:end_date]).strftime("%B #{Date.parse(params[:end_date]).day.ordinalize}, %Y") rescue nil

        pdf = WickedPdf.new.pdf_from_string(
          render_to_string(template: 'recaps/index.pdf.haml', layout: 'layouts/pdf.html.haml', locals:  { project_name: project.name, date_range: "#{start_date} - #{end_date}", reported_by: project.user_name }),
          orientation: 'Landscape'
        )

        file_name = "[#{project.name}] #{start_date} - #{end_date} - #{project.user_name}.pdf"
        save_path = Rails.root.join('tmp', file_name)
        File.open(save_path, 'wb') do |file|
          file << pdf
        end

        render json: {file_name: file_name}
      end
    end
  end

  # GET /recaps/1
  # GET /recaps/1.json
  def show
  end

  # GET /recaps/new
  def new
    @projects = Project.with_users.page(params[:page]).per(30)
  end

  # GET /recaps/1/edit
  def edit
  end

  # POST /recaps
  # POST /recaps.json
  def create
    @recap = Recap.new(recap_params)

    respond_to do |format|
      if @recap.valid?
        format.html { redirect_to @recap, notice: 'Recap was successfully created.' }
        format.json { render :show, status: :created, location: @recap }
      else
        format.html { render :new }
        format.json { render json: @recap.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recaps/1
  # PATCH/PUT /recaps/1.json
  def update
    respond_to do |format|
      if @recap.update(recap_params)
        format.html { redirect_to @recap, notice: 'Recap was successfully updated.' }
        format.json { render :show, status: :ok, location: @recap }
      else
        format.html { render :edit }
        format.json { render json: @recap.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recaps/1
  # DELETE /recaps/1.json
  def destroy
    @recap.destroy
    respond_to do |format|
      format.html { redirect_to recaps_url, notice: 'Recap was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def test
    @reports = Report.includes(:tasks).where(project_id: 1, user_id: 1, reported_at: "2017-02-01".."2017-02-28")
    project = Project.with_users.find_by(id: 1, users: {id: 1})
    respond_to do |format|
      format.html
      format.pdf do
        pdf = WickedPdf.new.pdf_from_string(
          render_to_string(template: 'recaps/index.pdf.haml', layout: 'layouts/pdf.html.haml', locals:  { project_name: project.name, date_range: "April 7th - 11th, 2014", reported_by: project.user_name }),
          orientation: 'Landscape'
        )

        file_name = "report_#{params[:project_id]}_#{params[:user_id]}.pdf"
        save_path = Rails.root.join('tmp', file_name)
        File.open(save_path, 'wb') do |file|
          file << pdf
        end

        send_data pdf, title: "test", filename: "test.pdf", type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  def download
    send_file Rails.root.join('tmp', "#{params[:file_name]}.pdf"), type: 'text/html'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recap
      @recap = Recap.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recap_params
      params.require(:recap).permit(:project_id, :user_id, :start_date, :end_date)
    end
end
