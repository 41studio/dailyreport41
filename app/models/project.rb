# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  description           :text(65535)
#  email_client          :string(255)
#  client_name           :string(255)
#  email_project_manager :string(255)
#  project_manager_name  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :integer
#  email_cc              :string(255)
#  email_bcc             :string(255)
#
# Indexes
#
#  index_projects_on_user_id  (user_id)
#

class Project < ActiveRecord::Base
  # relations
  belongs_to :user
  has_many :reports

  # validations
  validates :name, :client_name, :project_manager_name, presence: true, length: { maximum: 200 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :email_client, :email_project_manager, presence: true, format: { with: Devise.email_regexp }, length: { maximum: 200 }
  validates :email_cc, :email_bcc, length: { maximum: 200 }

  def email_to
    emails = []
    emails << email_client
    emails << email_project_manager unless email_client.eql?(email_project_manager)
    emails.join(', ')
  end
end