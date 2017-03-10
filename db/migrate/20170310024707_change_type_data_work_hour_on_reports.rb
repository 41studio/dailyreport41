class ChangeTypeDataWorkHourOnReports < ActiveRecord::Migration
  def up
    change_column :reports, :work_hour, :float, default: 8.0
  end

  def down
    change_column :reports, :work_hour, :decimal, default: 8.0
  end
end
