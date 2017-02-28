class RecapsController < ApplicationController
  before_action :set_recap, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:view]
  load_and_authorize_resource

  # GET /recaps
  # GET /recaps.json
  def index
    recap_range =
      if params.key?(:start_date) and params.key?(:end_date)
        date_to_range(params[:start_date], params[:end_date])
      else
        current_date = Time.zone.now
        date_to_range(current_date.beginning_of_week.strftime("%Y%m%d"), current_date.end_of_week.strftime("%Y%m%d"))
      end

    @projects = Project.joins(user: :reports).where.not(last_updated: nil).where(reports: {reported_at: recap_range}).select("projects.id, projects.name, projects.last_updated, projects.user_id, users.full_name AS user_name").order(last_updated: :desc).group("projects.id, projects.name, projects.last_updated, projects.user_id, users.full_name")
    @projects = @projects.where("projects.name ILIKE ?",   "%#{params[:project]}%")       if params[:project].present?
    @projects = @projects.where("users.full_name ILIKE ?", "%#{params[:reported_by]}%")   if params[:reported_by].present?
    @projects = @projects.page(params[:page]).per(20)
  end

  # GET /recaps/1
  # GET /recaps/1.json
  def show
  end

  # GET /recaps/new
  def new
    @projects = Project.with_users.page(params[:page]).per(20)
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
    @results = {}
    project = Project.find_by(id: params[:project_id])
    @results[:project_name] = project.try(:name)
    @results[:project_user_name] = project.try(:user).try(:full_name)
    @results[:reports] = Report.filter_by(params)

    start_date = Date.parse(params[:start_date]).strftime("%B #{Date.parse(params[:start_date]).day.ordinalize}, %Y") rescue nil
    end_date = Date.parse(params[:end_date]).strftime("%B #{Date.parse(params[:end_date]).day.ordinalize}, %Y") rescue nil
    @results[:date_range] = "#{start_date} - #{end_date}"
    @results[:title_recap] = "[#{@results[:project_name]}] #{@results[:date_range]} - #{@results[:project_user_name]}"
    @results[:total_work_hour] = @results[:reports].map(&:work_hour).sum
    respond_to_pdf("#{@results[:title_recap]}.pdf")
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

    def date_to_range(start_date, end_date)
      start_date.concat('T00:00:00')..end_date.concat('T23:59:59')
    end

    def respond_to_pdf(filename)
      respond_to do |format|
        format.html {render layout: false}
        format.pdf do
          pdf = WickedPdf.new.pdf_from_url(view_recaps_url(pdf: true), {
            orientation: 'Landscape',
            page_size: 'A4',
            margin: {
              top:    10,
              bottom: 10,
              left:   10,
              right:  10
            }
          })

          send_data(pdf, filename: filename, type: "application/pdf")
        end
      end
    end
end
