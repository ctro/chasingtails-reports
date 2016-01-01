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

ActiveRecord::Schema.define(version: 20160101202401) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "clients", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "clients", ["deleted_at"], name: "index_clients_on_deleted_at", using: :btree

  create_table "dogs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
    t.datetime "deleted_at"
  end

  add_index "dogs", ["deleted_at"], name: "index_dogs_on_deleted_at", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "asset_id",   limit: 255
  end

  create_table "report_dogs", force: :cascade do |t|
    t.integer  "dog_id"
    t.integer  "report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "report_dogs", ["deleted_at"], name: "index_report_dogs_on_deleted_at", using: :btree

  create_table "reports", force: :cascade do |t|
    t.date     "walk_date"
    t.string   "walk_time",     limit: 255
    t.string   "weather",       limit: 255
    t.text     "recap"
    t.string   "pees",          limit: 255
    t.string   "poops",         limit: 255
    t.string   "energy",        limit: 255
    t.string   "vocalization",  limit: 255
    t.string   "overall",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "walk_duration"
    t.integer  "client_id"
    t.string   "uuid",          limit: 255
    t.integer  "user_id"
    t.datetime "deleted_at"
    t.boolean  "no_show",                   default: false
  end

  add_index "reports", ["deleted_at"], name: "index_reports_on_deleted_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.string   "name",                   limit: 255
    t.datetime "deleted_at"
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
