class ReportTemplate < Mustache
  self.template_extension = 'html'
  self.template_file = File.join(Rails.root.join('app/views/templates'), 'report.html')

  def initialize(report)
    @report = report
    @tasks = report.tasks.order(:id)
  end

  def greeting
    "Hi #{@report.try(:project).try(:client_first_name)},"
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
end
