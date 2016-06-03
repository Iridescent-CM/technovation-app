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

ActiveRecord::Schema.define(version: 20160420142348) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                               default: 0,  null: false
    t.string   "country",                limit: 255
    t.string   "state",                  limit: 255
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "announcements", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "post"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                   default: 0, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
    t.integer  "team_id"
  end

  add_index "categories", ["team_id"], name: "index_categories_on_team_id", using: :btree

  create_table "country_codes", force: :cascade do |t|
    t.string "name", limit: 64, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "location",    limit: 255
    t.datetime "whentooccur"
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "organizer",   limit: 255
    t.integer  "team_id"
    t.integer  "region_id"
    t.boolean  "is_virtual"
  end

  add_index "events", ["region_id"], name: "index_events_on_region_id", using: :btree
  add_index "events", ["team_id"], name: "index_events_on_team_id", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "region_name",   limit: 255
    t.integer  "division"
    t.integer  "num_finalists",             default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rubrics", force: :cascade do |t|
    t.integer  "identify_problem"
    t.integer  "address_problem"
    t.integer  "functional"
    t.integer  "external_resources"
    t.integer  "match_features"
    t.integer  "interface"
    t.integer  "description"
    t.integer  "market"
    t.integer  "competition"
    t.integer  "revenue"
    t.integer  "branding"
    t.integer  "pitch"
    t.boolean  "launched"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
    t.integer  "user_id"
    t.string   "round",                      limit: 255
    t.integer  "score"
    t.text     "identify_problem_comment"
    t.text     "address_problem_comment"
    t.text     "functional_comment"
    t.text     "external_resources_comment"
    t.text     "match_features_comment"
    t.text     "interface_comment"
    t.text     "description_comment"
    t.text     "market_comment"
    t.text     "competition_comment"
    t.text     "revenue_comment"
    t.text     "branding_comment"
    t.text     "pitch_comment"
    t.text     "launched_comment"
    t.integer  "stage"
  end

  add_index "rubrics", ["user_id"], name: "index_rubrics_on_user_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "key",        limit: 255, null: false
    t.string   "value",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["key"], name: "index_settings_on_key", unique: true, using: :btree

  create_table "team_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.boolean  "user_request", default: true,  null: false
    t.boolean  "approved",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",                        limit: 255
    t.text     "about"
    t.integer  "year",                                    default: 2014, null: false
    t.integer  "division",                                default: 2,    null: false
    t.integer  "region_id",                                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name",            limit: 255
    t.string   "avatar_content_type",         limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "slug",                        limit: 255
    t.string   "country",                     limit: 2,   default: "",   null: false
    t.text     "description"
    t.string   "code",                        limit: 255
    t.string   "pitch",                       limit: 255
    t.string   "demo",                        limit: 255
    t.string   "logo_file_name",              limit: 255
    t.string   "logo_content_type",           limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "plan_file_name",              limit: 255
    t.string   "plan_content_type",           limit: 255
    t.integer  "plan_file_size"
    t.datetime "plan_updated_at"
    t.integer  "category_id"
    t.string   "screenshot1_file_name",       limit: 255
    t.string   "screenshot1_content_type",    limit: 255
    t.integer  "screenshot1_file_size"
    t.datetime "screenshot1_updated_at"
    t.string   "screenshot2_file_name",       limit: 255
    t.string   "screenshot2_content_type",    limit: 255
    t.integer  "screenshot2_file_size"
    t.datetime "screenshot2_updated_at"
    t.string   "screenshot3_file_name",       limit: 255
    t.string   "screenshot3_content_type",    limit: 255
    t.integer  "screenshot3_file_size"
    t.datetime "screenshot3_updated_at"
    t.string   "screenshot4_file_name",       limit: 255
    t.string   "screenshot4_content_type",    limit: 255
    t.integer  "screenshot4_file_size"
    t.datetime "screenshot4_updated_at"
    t.string   "screenshot5_file_name",       limit: 255
    t.string   "screenshot5_content_type",    limit: 255
    t.integer  "screenshot5_file_size"
    t.datetime "screenshot5_updated_at"
    t.integer  "event_id"
    t.boolean  "issemifinalist"
    t.boolean  "isfinalist"
    t.string   "store",                       limit: 255
    t.boolean  "iswinner"
    t.text     "tools"
    t.integer  "platform",                                default: 0,    null: false
    t.text     "challenge"
    t.text     "participation"
    t.boolean  "submitted"
    t.string   "state",                       limit: 255
    t.boolean  "confirm_region"
    t.boolean  "confirm_acceptance_of_rules"
  end

  add_index "teams", ["division"], name: "index_teams_on_division", using: :btree
  add_index "teams", ["event_id"], name: "index_teams_on_event_id", using: :btree
  add_index "teams", ["region_id"], name: "index_teams_on_region_id", using: :btree
  add_index "teams", ["slug"], name: "index_teams_on_slug", unique: true, using: :btree
  add_index "teams", ["year"], name: "index_teams_on_year", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                               default: 0,     null: false
    t.string   "first_name",             limit: 255,                 null: false
    t.string   "last_name",              limit: 255,                 null: false
    t.date     "birthday",                                           null: false
    t.text     "about"
    t.string   "home_city",              limit: 255
    t.string   "home_state",             limit: 255
    t.string   "postal_code",            limit: 255
    t.string   "home_country",           limit: 2,   default: "",    null: false
    t.string   "school",                 limit: 255
    t.string   "grade",                  limit: 255
    t.string   "salutation",             limit: 255
    t.boolean  "connect_with_other"
    t.integer  "expertise",                          default: 0,     null: false
    t.string   "parent_first_name",      limit: 255
    t.string   "parent_last_name",       limit: 255
    t.string   "parent_phone",           limit: 255, default: "",    null: false
    t.string   "parent_email",           limit: 255
    t.datetime "consent_signed_at"
    t.datetime "consent_sent_at"
    t.integer  "referral_category"
    t.text     "referral_details",                   default: ""
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "slug",                   limit: 255
    t.string   "bg_check_id",            limit: 255
    t.datetime "bg_check_submitted"
    t.boolean  "disabled",                           default: false, null: false
    t.boolean  "is_survey_done",                     default: false, null: false
    t.integer  "event_id"
    t.boolean  "judging"
    t.integer  "conflict_region_id"
    t.integer  "judging_region_id"
    t.boolean  "semifinals_judge"
    t.boolean  "finals_judge"
    t.boolean  "is_registered",                      default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["conflict_region_id"], name: "index_users_on_conflict_region_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["event_id"], name: "index_users_on_event_id", using: :btree
  add_index "users", ["judging_region_id"], name: "index_users_on_judging_region_id", using: :btree
  add_index "users", ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude", using: :btree
  add_index "users", ["parent_email"], name: "index_users_on_parent_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

end
