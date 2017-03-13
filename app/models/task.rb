# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  title      :text
#  status     :string
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

  serialize :completed, JSON

  # relations
  belongs_to :user
  belongs_to :report

  # validations
  validates :title, presence: true
  validates :status, presence: true

  # scope
  scope :completed, -> { with_status(:completed) }
  scope :on_progress, -> { with_status(:on_progress) }

  before_save :convert_to_new_line

  private
    def convert_to_new_line
      self.title = title.gsub(/\n/, '<br>')
    end
end
