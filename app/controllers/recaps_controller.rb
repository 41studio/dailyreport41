class RecapsController < ApplicationController
  before_action :set_recap, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:view]

  # GET /recaps
  # GET /recaps.json
  def index
    @projects = Project.with_users.page(params[:page]).per(30)
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

  def view
    @project = Project.with_users.find_by(id: params[:project_id], user_id: params[:user_id])
    @reports = Report.select(:id, :reported_at, :work_hour).includes(:tasks).where(project_id: @project.id, user_id: params[:user_id], reported_at: params[:start_date]..params[:end_date]).group("reports.id")

    start_date = Date.parse(params[:start_date]).strftime("%B #{Date.parse(params[:start_date]).day.ordinalize}, %Y") rescue nil
    end_date = Date.parse(params[:end_date]).strftime("%B #{Date.parse(params[:end_date]).day.ordinalize}, %Y") rescue nil
    @date_range = "#{start_date} - #{end_date}"
    respond_to do |format|
      format.html {render layout: false}
      format.pdf do
        pdf = WickedPdf.new.pdf_from_url(view_recaps_url(params.slice(:start_date, :end_date).merge({pdf: true})), {
          orientation: 'Landscape',
          margin: {
            top:    10,
            bottom: 10,
            left:   10,
            right:  10
          }
        })

        send_data(pdf, filename: "[#{@project.name}] #{start_date} - #{end_date} - #{@project.user_name}.pdf", type: "application/pdf")
      end
    end
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
