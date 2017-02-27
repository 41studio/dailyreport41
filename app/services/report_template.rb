class ReportTemplate < Mustache
  include ActionView::Helpers::AssetUrlHelper
  self.template_extension = 'html'
  self.template_file = File.join(Rails.root.join('app/views/templates'), 'report_themed.html')

  def initialize(report)
    @report = report
    @tasks = report.tasks.order(:id)
    @full_name = report.user.full_name
    @role = report.user.role
  end

  def greeting
    "Hi #{@report.try(:project).try(:client_first_name)},"
  end

  def first_name
    @full_name.split[0] rescue nil
  end

  def full_name
    @full_name
  end

  def role
    if @role.eql?('ios_developer')
      "iOS Developer"
    else
      ['ceo', 'bde'].include?(@role) ? @role.upcase : @role.titleize
    end
  rescue
    nil
  end

  def subject
    @report.subject_text
  end

  def body
    @report.body
  end

  def on_progress_tasks
    @tasks.select{|task| task.status.eql?('on_progress') }.as_json
  end

  def completed_tasks
    @tasks.select{|task| task.status.eql?('completed') }.as_json
  end

  def note
    Markdown.new(@report.note).to_html
  end

  def user_full_name
    @report.try(:user).try(:full_name)
  end

  def is_on_progress_tasks?
    @tasks.select{|task| task.status.eql?('on_progress') }.present?
  end

  def is_completed_tasks?
    @tasks.select{|task| task.status.eql?('completed') }.present?
  end

  def note?
    @report.note.present?
  end

  def host_url
    "http://dailyreport41.herokuapp.com"
  end

  def logo
    "#{host_url}/images/logo.jpg"
  end

  def header_logo
    "#{host_url}/images/header-logo-update.png"
  end

  def signature_full
    "#{host_url}/images/signature-full.png"
  end

  def border_top_footer
    "#{host_url}/images/border-top-footer.png"
  end

  def icon_marker
    "#{host_url}/images/icon-marker.png"
  end

  def icon_phone
    "#{host_url}/images/icon-phone.png"
  end

  def icon_envelope
    "#{host_url}/images/icon-envelop.png"
  end
end
