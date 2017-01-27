class AddResendToReports < ActiveRecord::Migration
  def change
    add_column :reports, :resend, :boolean, default: false
  end
end
