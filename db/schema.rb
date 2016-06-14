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

ActiveRecord::Schema.define(version: 20160613203318) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.string   "auth_token",      null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "authentications", ["email"], name: "index_authentications_on_email", using: :btree

  create_table "divisions", force: :cascade do |t|
    t.integer  "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",         null: false
    t.text     "description",  null: false
    t.string   "location",     null: false
    t.datetime "starts_at",    null: false
    t.integer  "organizer_id", null: false
    t.integer  "region_id",    null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "events", ["organizer_id"], name: "index_events_on_organizer_id", using: :btree
  add_index "events", ["region_id"], name: "index_events_on_region_id", using: :btree

  create_table "judge_expertises", force: :cascade do |t|
    t.integer  "user_role_id", null: false
    t.integer  "expertise_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "judge_expertises", ["expertise_id"], name: "index_judge_expertises_on_expertise_id", using: :btree
  add_index "judge_expertises", ["user_role_id"], name: "index_judge_expertises_on_user_role_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.datetime "approved_at"
    t.integer  "member_id",     null: false
    t.string   "member_type",   null: false
    t.integer  "joinable_id",   null: false
    t.string   "joinable_type", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "memberships", ["joinable_type", "joinable_id"], name: "index_memberships_on_joinable_type_and_joinable_id", using: :btree
  add_index "memberships", ["member_type", "member_id"], name: "index_memberships_on_member_type_and_member_id", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.integer  "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "score_categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "score_questions", force: :cascade do |t|
    t.integer  "score_category_id", null: false
    t.text     "label",             null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "score_questions", ["score_category_id"], name: "index_score_questions_on_score_category_id", using: :btree

  create_table "score_values", force: :cascade do |t|
    t.integer  "score_question_id", null: false
    t.integer  "value",             null: false
    t.text     "label",             null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "score_values", ["score_question_id"], name: "index_score_values_on_score_question_id", using: :btree

  create_table "score_values_scores", id: false, force: :cascade do |t|
    t.integer "score_value_id", null: false
    t.integer "score_id",       null: false
  end

  add_index "score_values_scores", ["score_id"], name: "index_score_values_scores_on_score_id", using: :btree
  add_index "score_values_scores", ["score_value_id"], name: "index_score_values_scores_on_score_value_id", using: :btree

  create_table "scores", force: :cascade do |t|
    t.integer  "submission_id", null: false
    t.integer  "judge_id",      null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "scores", ["judge_id"], name: "index_scores_on_judge_id", using: :btree
  add_index "scores", ["submission_id"], name: "index_scores_on_submission_id", using: :btree

  create_table "season_registrations", force: :cascade do |t|
    t.integer  "season_id",         null: false
    t.integer  "registerable_id",   null: false
    t.string   "registerable_type", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "season_registrations", ["registerable_id"], name: "season_registerable_ids", using: :btree
  add_index "season_registrations", ["registerable_type"], name: "season_registerable_types", using: :btree
  add_index "season_registrations", ["season_id"], name: "index_season_registrations_on_season_id", using: :btree

  create_table "seasons", force: :cascade do |t|
    t.integer  "year",       null: false
    t.datetime "starts_at",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "team_id",     null: false
    t.text     "description"
    t.string   "code"
    t.string   "pitch"
    t.string   "demo"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "submissions", ["team_id"], name: "index_submissions_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description", null: false
    t.integer  "division_id", null: false
    t.integer  "region_id",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "teams", ["division_id"], name: "index_teams_on_division_id", using: :btree
  add_index "teams", ["region_id"], name: "index_teams_on_region_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "role_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "authentication_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "users", ["authentication_id"], name: "index_users_on_authentication_id", using: :btree

  add_foreign_key "events", "regions"
  add_foreign_key "judge_expertises", "score_categories", column: "expertise_id"
  add_foreign_key "judge_expertises", "user_roles"
  add_foreign_key "score_questions", "score_categories"
  add_foreign_key "score_values", "score_questions"
  add_foreign_key "score_values_scores", "score_values"
  add_foreign_key "score_values_scores", "scores"
  add_foreign_key "scores", "submissions"
  add_foreign_key "scores", "user_roles", column: "judge_id"
  add_foreign_key "season_registrations", "seasons"
  add_foreign_key "submissions", "teams"
  add_foreign_key "teams", "divisions"
  add_foreign_key "teams", "regions"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "authentications"
end
