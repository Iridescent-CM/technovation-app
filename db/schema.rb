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

ActiveRecord::Schema.define(version: 20160926153416) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_exports", force: :cascade do |t|
    t.integer  "account_id", null: false
    t.string   "file",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "account_exports", ["account_id"], name: "index_account_exports_on_account_id", using: :btree
  add_index "account_exports", ["file"], name: "index_account_exports_on_file", using: :btree

  create_table "accounts", force: :cascade do |t|
    t.string   "email",                        null: false
    t.string   "password_digest",              null: false
    t.string   "auth_token",                   null: false
    t.string   "first_name",                   null: false
    t.string   "last_name",                    null: false
    t.date     "date_of_birth",                null: false
    t.string   "city",                         null: false
    t.string   "state_province"
    t.string   "country",                      null: false
    t.string   "type",                         null: false
    t.integer  "referred_by"
    t.string   "referred_by_other"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "consent_token"
    t.string   "profile_image"
    t.datetime "pre_survey_completed_at"
    t.string   "password_reset_token"
    t.datetime "password_reset_token_sent_at"
    t.integer  "gender"
    t.string   "last_login_ip"
  end

  add_index "accounts", ["auth_token"], name: "index_accounts_on_auth_token", unique: true, using: :btree
  add_index "accounts", ["consent_token"], name: "index_accounts_on_consent_token", unique: true, using: :btree
  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["gender"], name: "index_accounts_on_gender", using: :btree
  add_index "accounts", ["password_reset_token"], name: "index_accounts_on_password_reset_token", unique: true, using: :btree
  add_index "accounts", ["password_reset_token_sent_at"], name: "index_accounts_on_password_reset_token_sent_at", using: :btree
  add_index "accounts", ["referred_by"], name: "index_accounts_on_referred_by", using: :btree
  add_index "accounts", ["type"], name: "index_accounts_on_type", using: :btree

  create_table "admin_profiles", force: :cascade do |t|
    t.integer  "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "admin_profiles", ["account_id"], name: "index_admin_profiles_on_account_id", using: :btree

  create_table "consent_waivers", force: :cascade do |t|
    t.string   "electronic_signature", null: false
    t.integer  "account_id",           null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "consent_waivers", ["account_id"], name: "index_consent_waivers_on_account_id", using: :btree

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

  create_table "join_requests", force: :cascade do |t|
    t.integer  "requestor_id",   null: false
    t.string   "requestor_type", null: false
    t.integer  "joinable_id",    null: false
    t.string   "joinable_type",  null: false
    t.datetime "accepted_at"
    t.datetime "declined_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "join_requests", ["accepted_at"], name: "index_join_requests_on_accepted_at", using: :btree
  add_index "join_requests", ["declined_at"], name: "index_join_requests_on_declined_at", using: :btree
  add_index "join_requests", ["joinable_type", "joinable_id"], name: "index_join_requests_on_joinable_type_and_joinable_id", using: :btree
  add_index "join_requests", ["requestor_type", "requestor_id"], name: "index_join_requests_on_requestor_type_and_requestor_id", using: :btree

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

  create_table "mentor_profile_expertises", force: :cascade do |t|
    t.integer  "mentor_profile_id", null: false
    t.integer  "expertise_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "mentor_profile_expertises", ["expertise_id"], name: "index_mentor_profile_expertises_on_expertise_id", using: :btree
  add_index "mentor_profile_expertises", ["mentor_profile_id"], name: "index_mentor_profile_expertises_on_mentor_profile_id", using: :btree

  create_table "mentor_profiles", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "school_company_name",                           null: false
    t.string   "job_title",                                     null: false
    t.date     "background_check_completed_at"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.text     "bio"
    t.boolean  "searchable",                    default: false, null: false
    t.string   "background_check_candidate_id"
    t.string   "background_check_report_id"
    t.boolean  "accepting_team_invites",        default: true,  null: false
  end

  add_index "mentor_profiles", ["account_id"], name: "index_mentor_profiles_on_account_id", using: :btree
  add_index "mentor_profiles", ["searchable"], name: "index_mentor_profiles_on_searchable", using: :btree

  create_table "parental_consents", force: :cascade do |t|
    t.string   "electronic_signature", null: false
    t.integer  "account_id",           null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "voided_at"
  end

  add_index "parental_consents", ["account_id"], name: "index_parental_consents_on_account_id", using: :btree
  add_index "parental_consents", ["voided_at"], name: "index_parental_consents_on_voided_at", using: :btree

  create_table "regional_ambassador_profiles", force: :cascade do |t|
    t.string   "organization_company_name",                 null: false
    t.string   "ambassador_since_year",                     null: false
    t.string   "job_title",                                 null: false
    t.integer  "account_id",                                null: false
    t.integer  "status",                        default: 0, null: false
    t.datetime "background_check_completed_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.text     "bio"
    t.string   "background_check_candidate_id"
    t.string   "background_check_report_id"
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
    t.integer  "account_id",            null: false
    t.string   "parent_guardian_email"
    t.string   "parent_guardian_name"
    t.string   "school_name",           null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "student_profiles", ["account_id"], name: "index_student_profiles_on_account_id", using: :btree

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
    t.integer  "inviter_id",                null: false
    t.integer  "team_id",                   null: false
    t.string   "invitee_email"
    t.integer  "invitee_id"
    t.string   "invite_token",              null: false
    t.integer  "status",        default: 0, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "invitee_type"
  end

  add_index "team_member_invites", ["invite_token"], name: "index_team_member_invites_on_invite_token", unique: true, using: :btree
  add_index "team_member_invites", ["invitee_type"], name: "index_team_member_invites_on_invitee_type", using: :btree
  add_index "team_member_invites", ["status"], name: "index_team_member_invites_on_status", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",                                      null: false
    t.text     "description",                               null: false
    t.integer  "division_id",                               null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "team_photo"
    t.string   "friendly_id"
    t.boolean  "accepting_student_requests", default: true, null: false
    t.boolean  "accepting_mentor_requests",  default: true, null: false
  end

  add_index "teams", ["division_id"], name: "index_teams_on_division_id", using: :btree
  add_index "teams", ["friendly_id"], name: "index_teams_on_friendly_id", using: :btree

  add_foreign_key "account_exports", "accounts"
  add_foreign_key "account_exports", "accounts"
  add_foreign_key "admin_profiles", "accounts"
  add_foreign_key "consent_waivers", "accounts"
  add_foreign_key "join_requests", "accounts", column: "requestor_id"
  add_foreign_key "join_requests", "teams", column: "joinable_id"
  add_foreign_key "judge_scoring_expertises", "judge_profiles"
  add_foreign_key "judge_scoring_expertises", "score_categories", column: "scoring_expertise_id"
  add_foreign_key "mentor_profile_expertises", "expertises"
  add_foreign_key "mentor_profile_expertises", "mentor_profiles"
  add_foreign_key "mentor_profiles", "accounts"
  add_foreign_key "parental_consents", "accounts"
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
