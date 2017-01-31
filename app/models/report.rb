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
  validate :ensure_format_date

  ##
  # delegate class method
  delegate :name, :client_name, :email_client, :email_project_manager, :email_cc, :email_bcc, to: :project, prefix: true, allow_nil: true

  ##
  # callbacks
  after_initialize :set_default_message_body
  before_create :set_subject, :set_default_reported_at
  after_update  :ensure_resend_report

  ##
  # sending report with Gmail API
  def send_report
    gmail = GmailApi.new(user)
    body_template = ReportTemplate.new(self)
    message_id = gmail.deliver(email_to, email_cc, email_bcc, subject_text, body_template.render, format: 'html')
    self.update_column("message_id", message_id)
  end

  ##
  # formated subject
  def subject_text
    formated_date = reported_at.strftime("%B #{reported_at.day.ordinalize}, %Y")
    "[#{project_name}] Daily Report #{formated_date}"
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

    def set_default_reported_at
      self.reported_at = Date.today
    end

    def ensure_resend_report
      send_report if self.resend
    end

    def ensure_format_date
    end
end
