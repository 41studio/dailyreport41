class SendReportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(report_id)
    report = Report.find_by_id(report_id)
    if report.present?
      report.send!
    else
      puts "Not found report with ID=#{report_id}"
    end
  end
end
