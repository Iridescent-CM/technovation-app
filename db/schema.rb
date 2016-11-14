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

ActiveRecord::Schema.define(version: 20161111205925) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "accounts", force: :cascade do |t|
    t.string   "email",                                       null: false
    t.string   "password_digest",                             null: false
    t.string   "auth_token",                                  null: false
    t.string   "first_name",                                  null: false
    t.string   "last_name",                                   null: false
    t.date     "date_of_birth",                               null: false
    t.string   "city"
    t.string   "state_province"
    t.string   "country",                                     null: false
    t.integer  "referred_by"
    t.string   "referred_by_other"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "consent_token"
    t.string   "profile_image"
    t.datetime "pre_survey_completed_at"
    t.string   "password_reset_token"
    t.datetime "password_reset_token_sent_at"
    t.integer  "gender"
    t.string   "last_login_ip"
    t.string   "locale",                       default: "en", null: false
  end

  add_index "accounts", ["auth_token"], name: "index_accounts_on_auth_token", unique: true, using: :btree
  add_index "accounts", ["consent_token"], name: "index_accounts_on_consent_token", unique: true, using: :btree
  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["gender"], name: "index_accounts_on_gender", using: :btree
  add_index "accounts", ["password_reset_token"], name: "index_accounts_on_password_reset_token", unique: true, using: :btree
  add_index "accounts", ["password_reset_token_sent_at"], name: "index_accounts_on_password_reset_token_sent_at", using: :btree
  add_index "accounts", ["referred_by"], name: "index_accounts_on_referred_by", using: :btree

  create_table "admin_profiles", force: :cascade do |t|
    t.integer  "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "admin_profiles", ["account_id"], name: "index_admin_profiles_on_account_id", using: :btree

  create_table "background_checks", force: :cascade do |t|
    t.string   "candidate_id",             null: false
    t.string   "report_id",                null: false
    t.integer  "account_id",               null: false
    t.integer  "status",       default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "background_checks", ["account_id"], name: "index_background_checks_on_account_id", using: :btree
  add_index "background_checks", ["candidate_id"], name: "index_background_checks_on_candidate_id", using: :btree
  add_index "background_checks", ["report_id"], name: "index_background_checks_on_report_id", using: :btree

  create_table "consent_waivers", force: :cascade do |t|
    t.string   "electronic_signature", null: false
    t.integer  "account_id",           null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "voided_at"
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

  create_table "exports", force: :cascade do |t|
    t.integer  "account_id", null: false
    t.string   "file",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "exports", ["account_id"], name: "index_exports_on_account_id", using: :btree
  add_index "exports", ["file"], name: "index_exports_on_file", using: :btree

  create_table "honor_code_agreements", force: :cascade do |t|
    t.integer  "account_id",                           null: false
    t.string   "electronic_signature",                 null: false
    t.boolean  "agreement_confirmed",  default: false, null: false
    t.date     "voided_at"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "honor_code_agreements", ["account_id"], name: "index_honor_code_agreements_on_account_id", using: :btree

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
    t.string   "school_company_name",                    null: false
    t.string   "job_title",                              null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.text     "bio"
    t.boolean  "searchable",             default: false, null: false
    t.boolean  "accepting_team_invites", default: true,  null: false
    t.boolean  "virtual",                default: true,  null: false
  end

  add_index "mentor_profiles", ["account_id"], name: "index_mentor_profiles_on_account_id", using: :btree
  add_index "mentor_profiles", ["searchable"], name: "index_mentor_profiles_on_searchable", using: :btree
  add_index "mentor_profiles", ["virtual"], name: "index_mentor_profiles_on_virtual", using: :btree

  create_table "parental_consents", force: :cascade do |t|
    t.string   "electronic_signature", null: false
    t.integer  "student_profile_id",   null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "voided_at"
  end

  add_index "parental_consents", ["student_profile_id"], name: "index_parental_consents_on_student_profile_id", using: :btree
  add_index "parental_consents", ["voided_at"], name: "index_parental_consents_on_voided_at", using: :btree

  create_table "regional_ambassador_profiles", force: :cascade do |t|
    t.string   "organization_company_name",             null: false
    t.string   "ambassador_since_year",                 null: false
    t.string   "job_title",                             null: false
    t.integer  "account_id",                            null: false
    t.integer  "status",                    default: 0, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.text     "bio"
  end

  add_index "regional_ambassador_profiles", ["account_id"], name: "index_regional_ambassador_profiles_on_account_id", using: :btree
  add_index "regional_ambassador_profiles", ["ambassador_since_year"], name: "index_regional_ambassador_profiles_on_ambassador_since_year", using: :btree
  add_index "regional_ambassador_profiles", ["status"], name: "index_regional_ambassador_profiles_on_status", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "screenshots", force: :cascade do |t|
    t.integer  "team_submission_id"
    t.string   "image"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "screenshots", ["team_submission_id"], name: "index_screenshots_on_team_submission_id", using: :btree

  create_table "season_registrations", force: :cascade do |t|
    t.integer  "season_id",                     null: false
    t.integer  "registerable_id",               null: false
    t.string   "registerable_type",             null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "status",            default: 1, null: false
  end

  add_index "season_registrations", ["registerable_id"], name: "season_registerable_ids", using: :btree
  add_index "season_registrations", ["registerable_type"], name: "season_registerable_types", using: :btree
  add_index "season_registrations", ["season_id"], name: "index_season_registrations_on_season_id", using: :btree
  add_index "season_registrations", ["status"], name: "index_season_registrations_on_status", using: :btree

  create_table "seasons", force: :cascade do |t|
    t.integer  "year",       null: false
    t.datetime "starts_at",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "signup_attempts", force: :cascade do |t|
    t.string   "email",                        null: false
    t.string   "activation_token",             null: false
    t.integer  "account_id"
    t.integer  "status",           default: 0, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "signup_token"
    t.string   "pending_token"
    t.string   "password_digest"
  end

  add_index "signup_attempts", ["account_id"], name: "index_signup_attempts_on_account_id", using: :btree
  add_index "signup_attempts", ["activation_token"], name: "index_signup_attempts_on_activation_token", using: :btree
  add_index "signup_attempts", ["email"], name: "index_signup_attempts_on_email", using: :btree
  add_index "signup_attempts", ["pending_token"], name: "index_signup_attempts_on_pending_token", using: :btree
  add_index "signup_attempts", ["signup_token"], name: "index_signup_attempts_on_signup_token", using: :btree
  add_index "signup_attempts", ["status"], name: "index_signup_attempts_on_status", using: :btree

  create_table "student_profiles", force: :cascade do |t|
    t.integer  "account_id",            null: false
    t.string   "parent_guardian_email"
    t.string   "parent_guardian_name"
    t.string   "school_name",           null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "student_profiles", ["account_id"], name: "index_student_profiles_on_account_id", using: :btree

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
    t.string   "inviter_type"
  end

  add_index "team_member_invites", ["invite_token"], name: "index_team_member_invites_on_invite_token", unique: true, using: :btree
  add_index "team_member_invites", ["invitee_type"], name: "index_team_member_invites_on_invitee_type", using: :btree
  add_index "team_member_invites", ["status"], name: "index_team_member_invites_on_status", using: :btree

  create_table "team_submissions", force: :cascade do |t|
    t.boolean  "integrity_affirmed",       default: false, null: false
    t.integer  "team_id",                                  null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "source_code"
    t.string   "source_code_external_url"
    t.text     "app_description"
    t.integer  "stated_goal"
    t.text     "stated_goal_explanation"
    t.string   "app_name"
    t.string   "demo_video_link"
    t.string   "pitch_video_link"
  end

  add_index "team_submissions", ["stated_goal"], name: "index_team_submissions_on_stated_goal", using: :btree

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

  add_foreign_key "admin_profiles", "accounts"
  add_foreign_key "background_checks", "accounts"
  add_foreign_key "consent_waivers", "accounts"
  add_foreign_key "exports", "accounts"
  add_foreign_key "exports", "accounts"
  add_foreign_key "join_requests", "teams", column: "joinable_id"
  add_foreign_key "mentor_profile_expertises", "expertises"
  add_foreign_key "mentor_profile_expertises", "mentor_profiles"
  add_foreign_key "mentor_profiles", "accounts"
  add_foreign_key "parental_consents", "student_profiles"
  add_foreign_key "screenshots", "team_submissions"
  add_foreign_key "season_registrations", "seasons"
  add_foreign_key "signup_attempts", "accounts"
  add_foreign_key "team_submissions", "teams"
  add_foreign_key "teams", "divisions"
end
