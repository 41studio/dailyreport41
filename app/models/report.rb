# == Schema Information
#
# Table name: reports
#
#  id          :integer          not null, primary key
#  subject     :string(255)
#  body        :text(65535)
#  email_to    :string(255)
#  email_cc    :string(255)
#  email_bcc   :string(255)
#  reported_at :datetime
#  note        :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :integer
#  user_id     :integer
#  message_id  :string(255)
#  resend      :boolean          default("0")
#
# Indexes
#
#  index_reports_on_project_id  (project_id)
#  index_reports_on_user_id     (user_id)
#

class Report < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  ##
  # relations
  belongs_to :user
  belongs_to :project
  has_many :tasks, dependent: :destroy

  ##
  # nested attributes
  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true

  ##
  # validations
  validates :project_id, :body, :email_to, :reported_at, presence: true

  ##
  # delegate class method
  delegate :name, :client_name, :email_client, :email_project_manager, :email_cc, :email_bcc, to: :project, prefix: true, allow_nil: true

  ##
  # callbacks
  after_initialize :set_default_message_body
  before_create :set_subject
  after_create  :send_report
  after_update  :ensure_resend_report

  ##
  # sending report with Gmail API
  def send_report
    gmail = GmailApi.new(user)
    message_id = gmail.deliver(email_to, email_cc, email_bcc, subject_text, message_body, format: 'html')
    self.update_column("message_id", message_id)
  end

  ##
  # formated subject
  def subject_text
    "[#{project_name}] Daily Report #{reported_at.strftime('%B %d, %Y')}"
  end

  ##
  # formated message body
  def message_body
    ##
    # greeting
    html = "Hi #{project_client_name},"
    html += "<br>"
    html += simple_format(body)
    html += "<br>"

    ##
    # tasks
    if tasks.completed.present?
      html += "<strong>Completed:</strong>"
      html += "<ol>"
      tasks.completed.each do |task|
        html += "<li>#{task.title}</li>"
      end
      html += "</ol>"
    end

    if tasks.on_progress.present?
      html += "<strong>On Progress:</strong>"
      html += "<ol>"
      tasks.on_progress.each do |task|
        html += "<li>#{task.title}</li>"
      end
      html += "</ol>"
    end

    ##
    # notes
    if note.present?
      html += "<br>"
      html += "Note:"
      html += simple_format(note)
    end

    ##
    # close greeting
    html += "<br>"
    html += "Thank you"
    html += "<br>"
    html += "<br>"
    html += "Regards,"
    html += "<br>"
    html += user.full_name
    html
  end

  private
    ##
    # set default subject
    def set_subject
      self.subject = subject_text
    end

    def set_default_message_body
      self.body = "Today I have worked on this following tasks,"
    end

    def ensure_resend_report
      send_report if self.resend
    end
end
