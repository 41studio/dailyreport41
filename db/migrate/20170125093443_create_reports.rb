class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :subject
      t.text :body
      t.string :email_to
      t.string :email_cc
      t.string :email_bcc
      t.datetime :reported_at
      t.text :note

      t.timestamps null: false
    end
  end
end
