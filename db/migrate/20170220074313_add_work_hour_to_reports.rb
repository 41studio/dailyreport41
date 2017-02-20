class AddWorkHourToReports < ActiveRecord::Migration
  def change
    add_column :reports, :work_hour, :decimal, default: 8.0
  end
end
