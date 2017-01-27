class AddMessageIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :message_id, :string
  end
end
