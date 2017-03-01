# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  name                  :string
#  description           :text
#  email_client          :string
#  client_name           :string
#  email_project_manager :string
#  project_manager_name  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :integer
#  email_cc              :string
#  email_bcc             :string
#  slug                  :string
#  last_updated          :datetime
#
# Indexes
#
#  index_projects_on_slug     (slug) UNIQUE
#  index_projects_on_user_id  (user_id)
#

class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  # relations
  belongs_to :user
  has_many :reports

  # validations
  validates :name, :client_name, :project_manager_name, presence: true, length: { maximum: 200 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :email_client, :email_project_manager, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, length: { maximum: 200 }
  validates :email_cc, :email_bcc, length: { maximum: 200 }, email_addresses: true

  # scope
  scope :latest, -> { order(created_at: :desc) }
  scope :ordered, -> { order(name: :asc) }

  def client_first_name
    client_name.try(:split).try(:first)
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  def email_cc_text
    texts = []
    texts << email_project_manager unless email_client.eql?(email_project_manager)
    texts << email_cc if email_cc.present?
    text = texts.join(",")
  end
end
