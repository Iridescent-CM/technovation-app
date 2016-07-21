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

ActiveRecord::Schema.define(version: 20160720225156) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "email",             null: false
    t.string   "password_digest",   null: false
    t.string   "auth_token",        null: false
    t.string   "first_name",        null: false
    t.string   "last_name",         null: false
    t.date     "date_of_birth",     null: false
    t.string   "city",              null: false
    t.string   "state_province",    null: false
    t.string   "country",           null: false
    t.date     "consent_signed_at"
    t.string   "type",              null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "accounts", ["auth_token"], name: "index_accounts_on_auth_token", unique: true, using: :btree
  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["type"], name: "index_accounts_on_type", using: :btree

  create_table "admin_profiles", force: :cascade do |t|
    t.integer  "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "admin_profiles", ["account_id"], name: "index_admin_profiles_on_account_id", using: :btree

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
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "events", ["organizer_id"], name: "index_events_on_organizer_id", using: :btree

  create_table "expertises", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guidance_profile_expertises", force: :cascade do |t|
    t.integer  "guidance_profile_id"
    t.integer  "expertise_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "guidance_profile_expertises", ["expertise_id"], name: "index_guidance_profile_expertises_on_expertise_id", using: :btree
  add_index "guidance_profile_expertises", ["guidance_profile_id"], name: "index_guidance_profile_expertises_on_guidance_profile_id", using: :btree

  create_table "guidance_profiles", force: :cascade do |t|
    t.string   "type"
    t.integer  "account_id"
    t.string   "school_company_name",           null: false
    t.string   "job_title",                     null: false
    t.date     "background_check_completed_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "guidance_profiles", ["account_id"], name: "index_guidance_profiles_on_account_id", using: :btree
  add_index "guidance_profiles", ["type"], name: "index_guidance_profiles_on_type", using: :btree

  create_table "judge_profiles", force: :cascade do |t|
    t.integer  "account_id",   null: false
    t.string   "company_name", null: false
    t.string   "job_title",    null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "judge_profiles", ["account_id"], name: "index_judge_profiles_on_account_id", using: :btree

  create_table "judge_scoring_expertises", force: :cascade do |t|
    t.integer  "judge_profile_id",     null: false
    t.integer  "scoring_expertise_id", null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "judge_scoring_expertises", ["judge_profile_id"], name: "index_judge_scoring_expertises_on_judge_profile_id", using: :btree
  add_index "judge_scoring_expertises", ["scoring_expertise_id"], name: "index_judge_scoring_expertises_on_scoring_expertise_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "member_id",     null: false
    t.string   "member_type",   null: false
    t.integer  "joinable_id",   null: false
    t.string   "joinable_type", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "memberships", ["joinable_type", "joinable_id"], name: "index_memberships_on_joinable_type_and_joinable_id", using: :btree
  add_index "memberships", ["member_type", "member_id"], name: "index_memberships_on_member_type_and_member_id", using: :btree

  create_table "regional_ambassador_profiles", force: :cascade do |t|
    t.string   "organization_company_name",             null: false
    t.integer  "ambassador_since_year",                 null: false
    t.integer  "account_id",                            null: false
    t.integer  "status",                    default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regional_ambassador_profiles", ["account_id"], name: "index_regional_ambassador_profiles_on_account_id", using: :btree
  add_index "regional_ambassador_profiles", ["ambassador_since_year"], name: "index_regional_ambassador_profiles_on_ambassador_since_year", using: :btree
  add_index "regional_ambassador_profiles", ["status"], name: "index_regional_ambassador_profiles_on_status", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "score_categories", force: :cascade do |t|
    t.string   "name",                         null: false
    t.boolean  "is_expertise", default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
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

  create_table "scored_values", force: :cascade do |t|
    t.integer "score_value_id", null: false
    t.integer "score_id",       null: false
    t.text    "comment"
  end

  add_index "scored_values", ["score_id"], name: "index_scored_values_on_score_id", using: :btree
  add_index "scored_values", ["score_value_id"], name: "index_scored_values_on_score_value_id", using: :btree

  create_table "scores", force: :cascade do |t|
    t.integer  "submission_id",    null: false
    t.integer  "judge_profile_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "scores", ["judge_profile_id"], name: "index_scores_on_judge_profile_id", using: :btree
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

  create_table "student_profiles", force: :cascade do |t|
    t.integer  "account_id",              null: false
    t.string   "parent_guardian_email",   null: false
    t.string   "parent_guardian_name",    null: false
    t.string   "school_name",             null: false
    t.boolean  "is_in_secondary_school",  null: false
    t.date     "pre_survey_completed_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "student_profiles", ["account_id"], name: "index_student_profiles_on_account_id", using: :btree
  add_index "student_profiles", ["is_in_secondary_school"], name: "index_student_profiles_on_is_in_secondary_school", using: :btree

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

  create_table "team_member_invites", force: :cascade do |t|
    t.integer  "inviter_id",    null: false
    t.integer  "team_id",       null: false
    t.string   "invitee_email"
    t.integer  "invitee_id"
    t.string   "invite_token",  null: false
    t.datetime "accepted_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "team_member_invites", ["accepted_at"], name: "index_team_member_invites_on_accepted_at", using: :btree
  add_index "team_member_invites", ["invite_token"], name: "index_team_member_invites_on_invite_token", unique: true, using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description", null: false
    t.integer  "division_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "teams", ["division_id"], name: "index_teams_on_division_id", using: :btree

  add_foreign_key "admin_profiles", "accounts"
  add_foreign_key "guidance_profile_expertises", "expertises"
  add_foreign_key "guidance_profile_expertises", "guidance_profiles"
  add_foreign_key "guidance_profiles", "accounts"
  add_foreign_key "judge_scoring_expertises", "judge_profiles"
  add_foreign_key "judge_scoring_expertises", "score_categories", column: "scoring_expertise_id"
  add_foreign_key "score_questions", "score_categories"
  add_foreign_key "score_values", "score_questions"
  add_foreign_key "scored_values", "score_values"
  add_foreign_key "scored_values", "scores"
  add_foreign_key "scores", "judge_profiles"
  add_foreign_key "scores", "submissions"
  add_foreign_key "season_registrations", "seasons"
  add_foreign_key "submissions", "teams"
  add_foreign_key "team_member_invites", "accounts", column: "invitee_id"
  add_foreign_key "team_member_invites", "accounts", column: "inviter_id"
  add_foreign_key "teams", "divisions"
end
