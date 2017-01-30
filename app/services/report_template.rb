class ReportTemplate < Mustache

  self.template_file = File.join(Rails.root.join('app/views/templates'), 'report.html')

  def initialize(report)
    @report = report
  end

  def greeting
    "Hi #{@report.try(:project).try(:client_first_name)},"
  end

  def body
    @report.body
  end

  def on_progress_tasks
    { "on_progress_tasks" => JSON.parse(@report.tasks.on_progress.to_json) }
  end

  def completed_tasks
    { "completed_tasks" => JSON.parse(@report.tasks.completed.to_json) }
  end

  def note
    @report.note
  end

  def user_full_name
    @report.try(:user).try(:full_name)
  end
end
