# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  report_id  :integer
#
# Indexes
#
#  index_tasks_on_report_id  (report_id)
#

class Task < ActiveRecord::Base
  extend Enumerize

  enumerize :status, in: [:on_progress, :completed], predicates: true, scope: true

  # relations
  belongs_to :user
  belongs_to :report

  # validations
  validates :title, presence: true, length: { maximum: 200 }
  validates :status, presence: true

  # scope
  scope :completed, -> { with_status(:completed) }
  scope :on_progress, -> { with_status(:on_progress) }
end
