# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170222110708) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "email_client"
    t.string   "client_name"
    t.string   "email_project_manager"
    t.string   "project_manager_name"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "user_id"
    t.string   "email_cc"
    t.string   "email_bcc"
    t.string   "slug"
    t.datetime "last_updated"
  end

  add_index "projects", ["slug"], name: "index_projects_on_slug", unique: true, using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "recaps", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "recaps", ["project_id"], name: "index_recaps_on_project_id", using: :btree
  add_index "recaps", ["user_id"], name: "index_recaps_on_user_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.string   "subject"
    t.text     "body"
    t.string   "email_to"
    t.string   "email_cc"
    t.string   "email_bcc"
    t.datetime "reported_at"
    t.text     "note"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "message_id"
    t.boolean  "resend",      default: false
    t.string   "slug"
    t.decimal  "work_hour",   default: 8.0
  end

  add_index "reports", ["project_id"], name: "index_reports_on_project_id", using: :btree
  add_index "reports", ["slug"], name: "index_reports_on_slug", unique: true, using: :btree
  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "report_id"
  end

  add_index "tasks", ["report_id"], name: "index_tasks_on_report_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.string   "full_name"
    t.integer  "role",                   default: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "projects", "users"
  add_foreign_key "recaps", "projects"
  add_foreign_key "recaps", "users"
  add_foreign_key "reports", "projects"
  add_foreign_key "reports", "users"
  add_foreign_key "tasks", "reports"
end
