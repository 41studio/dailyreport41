class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :email_client
      t.string :client_name
      t.string :email_project_manager
      t.string :project_manager_name

      t.timestamps null: false
    end
  end
end
