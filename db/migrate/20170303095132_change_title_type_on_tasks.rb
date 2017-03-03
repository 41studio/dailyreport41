class ChangeTitleTypeOnTasks < ActiveRecord::Migration
  def up
    change_column(:tasks, :title, :text, limit: 1000)
  end

  def down
    change_column(:tasks, :title, :string)
  end
end
