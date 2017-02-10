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
#  resend      :boolean          default(FALSE)
#  slug        :string(255)
#
# Indexes
#
#  index_reports_on_project_id  (project_id)
#  index_reports_on_slug        (slug) UNIQUE
#  index_reports_on_user_id     (user_id)
#

class Report < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  extend FriendlyId

  friendly_id :slug_candidates, use: [:slugged, :finders, :scoped], scope: [:project]

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
  validate :ensure_valid_date

  ##
  # delegate class method
  delegate :name, :client_name, :email_client, :email_project_manager, :email_cc, :email_bcc, to: :project, prefix: true, allow_nil: true

  ##
  # callbacks
  after_initialize :set_default_message_body
  before_create :set_subject
  after_update  :ensure_resend_report

  ##
  # sending report with Gmail API
  def send!
    gmail = GmailApi.new(user)
    message_id = gmail.deliver(email_to, email_cc, email_bcc, subject_text, template, format: 'html')
    self.update_attributes(message_id: message_id) if message_id
  end

  def send_async!
    SendReportWorker.perform_async(id)
  end

  ##
  # formated subject
  def subject_text
    formated_date = reported_at.strftime("%B #{reported_at.day.ordinalize}, %Y")
    "[#{project_name}] Daily Report #{formated_date}"
  end

  def template
    ReportTemplate.new(self).render
  end

  def slug_candidates
    [
      [user.full_name.parameterize, project_name, reported_at.try(:strftime, '%d %B %Y')],
      [user.full_name.parameterize, project_name, reported_at.try(:strftime, '%d %B %Y'), SecureRandom.random_number(10)]
    ]
  end

  def should_generate_new_friendly_id?
    reported_at_changed? || project_id_changed? || super
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
      send_report if resend
    end

    def ensure_valid_date
      errors.add("Reported at date", "is invalid.") unless reported_at.present? and (Time.now.yesterday.to_date..Time.now.to_date).include?(reported_at.to_date)
    end
end
