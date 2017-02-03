class SendReportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(report_id)
    report = Report.find_by_id(report_id)
    if report.present?
      gmail = GmailApi.new(report.user)
      message_id = gmail.deliver(report.email_to, report.email_cc, report.email_bcc, report.subject_text, report.template, format: 'html')
      report.update_attributes(message_id: message_id)
    else
      puts "Not found report with ID=#{report_id}"
    end
  end
end
