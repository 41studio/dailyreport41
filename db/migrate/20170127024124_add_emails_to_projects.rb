class AddEmailsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :email_cc, :string
    add_column :projects, :email_bcc, :string
  end
end
