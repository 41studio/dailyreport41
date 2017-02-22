class AddLastUpdatedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :last_updated, :datetime
  end
end
