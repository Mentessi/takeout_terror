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

ActiveRecord::Schema.define(version: 20131117151152) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "establishments", force: true do |t|
    t.integer  "fhrsid"
    t.string   "local_authority_business_id"
    t.string   "business_name"
    t.string   "business_type"
    t.string   "business_type_id"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "address_line_3"
    t.string   "address_line_4"
    t.string   "postcode"
    t.integer  "rating_value"
    t.string   "rating_key"
    t.datetime "rating_date"
    t.string   "local_authority_code"
    t.string   "local_authority_name"
    t.string   "local_authority_website"
    t.string   "local_authority_email_address"
    t.integer  "scores_hygiene"
    t.integer  "scores_structual"
    t.integer  "scores_confidence_in_management"
    t.string   "scheme_type"
    t.decimal  "Geocode_Longitude",               precision: 16, scale: 14
    t.decimal  "Geocode_Latitude",                precision: 16, scale: 14
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "omniauth_identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "score"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "visits", force: true do |t|
    t.integer  "user_id"
    t.integer  "establishment_id"
    t.integer  "fs_rating_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
