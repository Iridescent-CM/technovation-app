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

ActiveRecord::Schema.define(version: 20170628201104) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_stat_statements"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "auth_token", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.date "date_of_birth", null: false
    t.string "city"
    t.string "state_province"
    t.string "country"
    t.integer "referred_by"
    t.string "referred_by_other"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "consent_token"
    t.string "profile_image"
    t.datetime "pre_survey_completed_at"
    t.string "password_reset_token"
    t.datetime "password_reset_token_sent_at"
    t.integer "gender"
    t.string "last_login_ip"
    t.string "locale", default: "en", null: false
    t.string "timezone"
    t.boolean "location_confirmed"
    t.string "browser_name"
    t.string "browser_version"
    t.string "os_name"
    t.string "os_version"
    t.index ["auth_token"], name: "index_accounts_on_auth_token", unique: true
    t.index ["consent_token"], name: "index_accounts_on_consent_token", unique: true
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["password_reset_token"], name: "index_accounts_on_password_reset_token", unique: true
  end

  create_table "admin_profiles", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_admin_profiles_on_account_id"
  end

  create_table "background_checks", id: :serial, force: :cascade do |t|
    t.string "candidate_id", null: false
    t.string "report_id", null: false
    t.integer "account_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_background_checks_on_account_id"
  end

  create_table "business_plans", id: :serial, force: :cascade do |t|
    t.string "uploaded_file"
    t.string "remote_file_url"
    t.integer "team_submission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "file_uploaded"
    t.index ["team_submission_id"], name: "index_business_plans_on_team_submission_id"
  end

  create_table "certificates", force: :cascade do |t|
    t.bigint "account_id"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "season"
    t.integer "cert_type"
    t.index ["account_id"], name: "index_certificates_on_account_id"
  end

  create_table "consent_waivers", id: :serial, force: :cascade do |t|
    t.string "electronic_signature", null: false
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "voided_at"
    t.index ["account_id"], name: "index_consent_waivers_on_account_id"
  end

  create_table "divisions", id: :serial, force: :cascade do |t|
    t.integer "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "divisions_regional_pitch_events", id: false, force: :cascade do |t|
    t.integer "division_id"
    t.integer "regional_pitch_event_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.string "location", null: false
    t.datetime "starts_at", null: false
    t.integer "organizer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organizer_id"], name: "index_events_on_organizer_id"
  end

  create_table "expertises", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exports", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "file", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "download_token"
  end

  create_table "honor_code_agreements", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "electronic_signature", null: false
    t.boolean "agreement_confirmed", default: false, null: false
    t.date "voided_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_honor_code_agreements_on_account_id"
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.string "job_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "join_requests", id: :serial, force: :cascade do |t|
    t.integer "requestor_id", null: false
    t.string "requestor_type", null: false
    t.integer "joinable_id", null: false
    t.string "joinable_type", null: false
    t.datetime "accepted_at"
    t.datetime "declined_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["joinable_type", "joinable_id"], name: "index_join_requests_on_joinable_type_and_joinable_id"
    t.index ["requestor_type", "requestor_id"], name: "index_join_requests_on_requestor_type_and_requestor_id"
  end

  create_table "judge_assignments", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "judge_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["judge_profile_id"], name: "index_judge_assignments_on_judge_profile_id"
    t.index ["team_id"], name: "index_judge_assignments_on_team_id"
  end

  create_table "judge_profiles", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "company_name", null: false
    t.string "job_title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_judge_profiles_on_account_id"
  end

  create_table "judge_profiles_regional_pitch_events", id: false, force: :cascade do |t|
    t.integer "judge_profile_id"
    t.integer "regional_pitch_event_id"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "member_id", null: false
    t.string "member_type", null: false
    t.integer "joinable_id", null: false
    t.string "joinable_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["joinable_type", "joinable_id"], name: "index_memberships_on_joinable_type_and_joinable_id"
    t.index ["member_type", "member_id"], name: "index_memberships_on_member_type_and_member_id"
  end

  create_table "mentor_profile_expertises", id: :serial, force: :cascade do |t|
    t.integer "mentor_profile_id", null: false
    t.integer "expertise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mentor_profile_id"], name: "index_mentor_profile_expertises_on_mentor_profile_id"
  end

  create_table "mentor_profiles", id: :serial, force: :cascade do |t|
    t.integer "account_id"
    t.string "school_company_name", null: false
    t.string "job_title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "bio"
    t.boolean "searchable", default: false, null: false
    t.boolean "accepting_team_invites", default: true, null: false
    t.boolean "virtual", default: true, null: false
    t.boolean "connect_with_mentors", default: true, null: false
    t.index ["account_id"], name: "index_mentor_profiles_on_account_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "recipient_id"
    t.string "recipient_type"
    t.integer "sender_id"
    t.string "sender_type"
    t.string "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "regarding_id"
    t.string "regarding_type"
    t.datetime "sent_at"
    t.datetime "delivered_at"
  end

  create_table "multi_messages", id: :serial, force: :cascade do |t|
    t.integer "sender_id", null: false
    t.string "sender_type", null: false
    t.integer "regarding_id", null: false
    t.string "regarding_type", null: false
    t.hstore "recipients", null: false
    t.string "subject"
    t.text "body", null: false
    t.datetime "sent_at"
    t.datetime "delivered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parental_consents", id: :serial, force: :cascade do |t|
    t.string "electronic_signature", null: false
    t.integer "student_profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "voided_at"
    t.boolean "newsletter_opt_in"
    t.index ["student_profile_id"], name: "index_parental_consents_on_student_profile_id"
  end

  create_table "pitch_presentations", id: :serial, force: :cascade do |t|
    t.string "uploaded_file"
    t.string "remote_file_url"
    t.integer "team_submission_id", null: false
    t.boolean "file_uploaded"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regional_ambassador_profiles", id: :serial, force: :cascade do |t|
    t.string "organization_company_name", null: false
    t.string "ambassador_since_year", null: false
    t.string "job_title", null: false
    t.integer "account_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "bio"
    t.index ["account_id"], name: "index_regional_ambassador_profiles_on_account_id"
    t.index ["status"], name: "index_regional_ambassador_profiles_on_status"
  end

  create_table "regional_pitch_events", id: :serial, force: :cascade do |t|
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.integer "regional_ambassador_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "division_id"
    t.string "city"
    t.string "venue_address"
    t.string "eventbrite_link"
    t.string "name"
    t.boolean "unofficial", default: false
    t.index ["division_id"], name: "index_regional_pitch_events_on_division_id"
  end

  create_table "regional_pitch_events_teams", id: false, force: :cascade do |t|
    t.integer "regional_pitch_event_id"
    t.integer "team_id"
    t.index ["regional_pitch_event_id", "team_id"], name: "pitch_events_teams", unique: true
    t.index ["team_id"], name: "pitch_events_team_ids"
  end

  create_table "regions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "screenshots", id: :serial, force: :cascade do |t|
    t.integer "team_submission_id"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_position", default: 0, null: false
    t.index ["team_submission_id"], name: "index_screenshots_on_team_submission_id"
  end

  create_table "season_registrations", id: :serial, force: :cascade do |t|
    t.integer "season_id", null: false
    t.integer "registerable_id", null: false
    t.string "registerable_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1, null: false
    t.index ["registerable_id"], name: "season_registerable_ids"
    t.index ["registerable_type"], name: "season_registerable_types"
    t.index ["season_id"], name: "index_season_registrations_on_season_id"
  end

  create_table "seasons", id: :serial, force: :cascade do |t|
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "signup_attempts", id: :serial, force: :cascade do |t|
    t.string "email", null: false
    t.string "activation_token", null: false
    t.integer "account_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "signup_token"
    t.string "pending_token"
    t.string "password_digest"
    t.string "admin_permission_token"
    t.index ["status"], name: "index_signup_attempts_on_status"
  end

  create_table "student_profiles", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "parent_guardian_email"
    t.string "parent_guardian_name"
    t.string "school_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_student_profiles_on_account_id"
  end

  create_table "submission_scores", id: :serial, force: :cascade do |t|
    t.integer "team_submission_id"
    t.integer "judge_profile_id"
    t.integer "sdg_alignment", default: 0
    t.integer "evidence_of_problem", default: 0
    t.integer "problem_addressed", default: 0
    t.integer "app_functional", default: 0
    t.integer "demo_video", default: 0
    t.integer "business_plan_short_term", default: 0
    t.integer "business_plan_long_term", default: 0
    t.integer "market_research", default: 0
    t.integer "viable_business_model", default: 0
    t.integer "problem_clearly_communicated", default: 0
    t.integer "compelling_argument", default: 0
    t.integer "passion_energy", default: 0
    t.integer "pitch_specific", default: 0
    t.integer "business_plan_feasible", default: 0
    t.integer "submission_thought_out", default: 0
    t.integer "cohesive_story", default: 0
    t.integer "solution_originality", default: 0
    t.integer "solution_stands_out", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "ideation_comment"
    t.text "technical_comment"
    t.text "entrepreneurship_comment"
    t.text "pitch_comment"
    t.text "overall_comment"
    t.datetime "completed_at"
    t.string "event_type"
    t.datetime "deleted_at"
    t.integer "round", default: 0, null: false
    t.boolean "official", default: true
    t.index ["completed_at"], name: "index_submission_scores_on_completed_at"
    t.index ["judge_profile_id"], name: "index_submission_scores_on_judge_profile_id"
    t.index ["team_submission_id"], name: "index_submission_scores_on_team_submission_id"
  end

  create_table "team_member_invites", id: :serial, force: :cascade do |t|
    t.integer "inviter_id", null: false
    t.integer "team_id", null: false
    t.string "invitee_email"
    t.integer "invitee_id"
    t.string "invite_token", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitee_type"
    t.string "inviter_type"
    t.index ["invite_token"], name: "index_team_member_invites_on_invite_token", unique: true
    t.index ["status"], name: "index_team_member_invites_on_status"
  end

  create_table "team_submissions", id: :serial, force: :cascade do |t|
    t.boolean "integrity_affirmed", default: false, null: false
    t.integer "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_code"
    t.string "source_code_external_url"
    t.text "app_description"
    t.integer "stated_goal"
    t.text "stated_goal_explanation"
    t.string "app_name"
    t.string "demo_video_link"
    t.string "pitch_video_link"
    t.string "development_platform_other"
    t.integer "development_platform"
    t.boolean "source_code_file_uploaded"
    t.string "slug"
    t.integer "submission_scores_count"
    t.integer "judge_opened_id"
    t.datetime "judge_opened_at"
    t.decimal "quarterfinals_average_score", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "average_unofficial_score", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "contest_rank", default: 0, null: false
    t.integer "complete_semifinals_submission_scores_count", default: 0, null: false
    t.integer "complete_quarterfinals_submission_scores_count", default: 0, null: false
    t.decimal "semifinals_average_score", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "complete_semifinals_official_submission_scores_count", default: 0, null: false
    t.integer "complete_quarterfinals_official_submission_scores_count", default: 0, null: false
    t.integer "pending_semifinals_submission_scores_count", default: 0, null: false
    t.integer "pending_quarterfinals_submission_scores_count", default: 0, null: false
    t.integer "pending_semifinals_official_submission_scores_count", default: 0, null: false
    t.integer "pending_quarterfinals_official_submission_scores_count", default: 0, null: false
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "division_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "team_photo"
    t.string "legacy_id"
    t.boolean "accepting_student_requests", default: true, null: false
    t.boolean "accepting_mentor_requests", default: true, null: false
    t.float "latitude"
    t.float "longitude"
    t.string "city"
    t.string "state_province"
    t.string "country"
    t.index ["legacy_id"], name: "index_teams_on_legacy_id"
  end

  create_table "technical_checklists", id: :serial, force: :cascade do |t|
    t.boolean "used_strings"
    t.string "used_strings_explanation"
    t.boolean "used_numbers"
    t.string "used_numbers_explanation"
    t.boolean "used_variables"
    t.string "used_variables_explanation"
    t.boolean "used_lists"
    t.string "used_lists_explanation"
    t.boolean "used_booleans"
    t.string "used_booleans_explanation"
    t.boolean "used_loops"
    t.string "used_loops_explanation"
    t.boolean "used_conditionals"
    t.string "used_conditionals_explanation"
    t.boolean "used_local_db"
    t.string "used_local_db_explanation"
    t.boolean "used_external_db"
    t.string "used_external_db_explanation"
    t.boolean "used_location_sensor"
    t.string "used_location_sensor_explanation"
    t.boolean "used_camera"
    t.string "used_camera_explanation"
    t.boolean "used_accelerometer"
    t.string "used_accelerometer_explanation"
    t.boolean "used_sms_phone"
    t.string "used_sms_phone_explanation"
    t.boolean "used_sound"
    t.string "used_sound_explanation"
    t.boolean "used_sharing"
    t.string "used_sharing_explanation"
    t.string "paper_prototype"
    t.integer "team_submission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "event_flow_chart"
    t.boolean "used_clock"
    t.string "used_clock_explanation"
    t.boolean "used_canvas"
    t.string "used_canvas_explanation"
    t.index ["team_submission_id"], name: "index_technical_checklists_on_team_submission_id"
  end

  add_foreign_key "admin_profiles", "accounts"
  add_foreign_key "background_checks", "accounts"
  add_foreign_key "business_plans", "team_submissions"
  add_foreign_key "certificates", "accounts"
  add_foreign_key "consent_waivers", "accounts"
  add_foreign_key "divisions_regional_pitch_events", "divisions"
  add_foreign_key "divisions_regional_pitch_events", "regional_pitch_events"
  add_foreign_key "exports", "accounts"
  add_foreign_key "join_requests", "teams", column: "joinable_id"
  add_foreign_key "judge_assignments", "judge_profiles"
  add_foreign_key "judge_assignments", "teams"
  add_foreign_key "mentor_profile_expertises", "expertises"
  add_foreign_key "mentor_profile_expertises", "mentor_profiles"
  add_foreign_key "mentor_profiles", "accounts"
  add_foreign_key "parental_consents", "student_profiles"
  add_foreign_key "regional_pitch_events", "divisions"
  add_foreign_key "regional_pitch_events_teams", "regional_pitch_events"
  add_foreign_key "regional_pitch_events_teams", "teams"
  add_foreign_key "screenshots", "team_submissions"
  add_foreign_key "season_registrations", "seasons"
  add_foreign_key "signup_attempts", "accounts"
  add_foreign_key "submission_scores", "judge_profiles"
  add_foreign_key "submission_scores", "team_submissions"
  add_foreign_key "team_submissions", "teams"
  add_foreign_key "teams", "divisions"
  add_foreign_key "technical_checklists", "team_submissions"
end
