# == Schema Information
#
# Table name: recaps
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  start_date :date
#  end_date   :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_recaps_on_project_id  (project_id)
#  index_recaps_on_user_id     (user_id)
#

class Recap < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :project_id, :user_id, :start_date, :end_date, presence: true
end
