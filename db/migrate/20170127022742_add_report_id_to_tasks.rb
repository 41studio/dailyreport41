class AddReportIdToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :report, index: true, foreign_key: true
  end
end
