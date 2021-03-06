# == Schema Information
#
# Table name: reports
#
#  id          :integer          not null, primary key
#  subject     :string
#  body        :text
#  email_to    :string
#  email_cc    :string
#  email_bcc   :string
#  reported_at :datetime
#  note        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :integer
#  user_id     :integer
#  message_id  :string
#  resend      :boolean          default(FALSE)
#  slug        :string
#  work_hour   :float            default(8.0)
#  end_letter  :text             default("If you have any question, feel free to contact me directly and I'll try my best to help.<br><br>Have a wonderful day ;)")
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

  attr_accessor :reported_date

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
  validates :project_id, :email_to, :reported_at, presence: true
  validates :email_to, :email_cc, :email_bcc, email_addresses: true
  # validate :ensure_valid_date

  scope :filter_by, -> (params) { select(:id, :reported_at, :work_hour).includes(:tasks).where(project_id: params[:project_id], reported_at: params[:start_date].concat("T00:00:00")..params[:end_date].concat("T23:59:59")).group("reports.id").order("reports.reported_at ASC")}
  ##
  # delegate class method
  delegate :name, :client_name, :email_client, :email_project_manager, :email_cc, :email_bcc, to: :project, prefix: true, allow_nil: true

  ##
  # callbacks
  # after_initialize :set_default_message_body
  before_create :set_subject, :set_default_message_body, :set_default_end_letter
  after_update  :ensure_resend_report
  after_save    :set_last_updated

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
    CGI.unescapeHTML ReportTemplate.new(self).render
  end

  def slug_candidates
    [
      [user.full_name.parameterize, project_name, reported_at.strftime('%d %B %Y'), SecureRandom.hex(4)]
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
      self.body = generate_body
    end

    def set_default_end_letter
      self.end_letter = generate_end_letter
    end

    def ensure_resend_report
      send_report if resend
    end

    def ensure_valid_date
      errors.add("Reported at date", "is invalid.") unless reported_at.present? and (Time.now.yesterday.to_date..Time.now.to_date).include?(reported_at.to_date)
    end

    def set_last_updated
      self.project.update_attributes(last_updated: reported_at)
    end

    def generate_body
      [
        "Today I have worked on these following tasks,",
        "Hope all things are good on your side.<br>Below are what I have done for today:"
      ].sample
    end

    def generate_end_letter
      [
        "If you have any question, feel free to contact me directly and I'll try my best to help.<br><br>Have a wonderful day ;)",
        "Please let me know if you have any feedback.<br><br>Have a nice day :)"
      ].sample
    end
end
