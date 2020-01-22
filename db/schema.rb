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

ActiveRecord::Schema.define(version: 20200115211026) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "unaccent"
  enable_extension "pg_trgm"

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
    t.string "browser_name"
    t.string "browser_version"
    t.string "os_name"
    t.string "os_version"
    t.datetime "email_confirmed_at"
    t.datetime "deleted_at"
    t.datetime "last_logged_in_at"
    t.text "seasons", default: [], array: true
    t.string "session_token"
    t.string "mailer_token"
    t.string "icon_path"
    t.bigint "division_id"
    t.datetime "survey_completed_at"
    t.datetime "reminded_about_survey_at"
    t.integer "reminded_about_survey_count", default: 0, null: false
    t.datetime "season_registered_at"
    t.integer "admin_status", default: 0, null: false
    t.string "admin_invitation_token"
    t.string "geocoding_city_was"
    t.string "geocoding_state_was"
    t.string "geocoding_country_was"
    t.datetime "geocoding_fixed_at"
    t.datetime "terms_agreed_at"
    t.index "email gist_trgm_ops", name: "trgm_email_indx", using: :gist
    t.index "first_name gist_trgm_ops", name: "trgm_first_name_indx", using: :gist
    t.index "last_name gist_trgm_ops", name: "trgm_last_name_indx", using: :gist
    t.index ["admin_invitation_token"], name: "index_accounts_on_admin_invitation_token", unique: true
    t.index ["auth_token"], name: "index_accounts_on_auth_token", unique: true
    t.index ["consent_token"], name: "index_accounts_on_consent_token", unique: true
    t.index ["division_id"], name: "index_accounts_on_division_id"
    t.index ["email"], name: "index_accounts_on_email", unique: true, where: "(deleted_at IS NULL)"
    t.index ["mailer_token"], name: "index_accounts_on_mailer_token", unique: true
    t.index ["password_reset_token"], name: "index_accounts_on_password_reset_token", unique: true
    t.index ["session_token"], name: "index_accounts_on_session_token", unique: true
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "trackable_type"
    t.integer "trackable_id"
    t.string "owner_type"
    t.integer "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.integer "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
  end

  create_table "admin_profiles", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "uniq_admins_accounts", unique: true
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
    t.integer "team_submission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_submission_id"], name: "index_business_plans_on_team_submission_id"
  end

  create_table "certificates", force: :cascade do |t|
    t.bigint "account_id"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "season"
    t.integer "cert_type"
    t.bigint "team_id"
    t.index ["account_id"], name: "index_certificates_on_account_id"
    t.index ["team_id"], name: "index_certificates_on_team_id"
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

  create_table "expertises", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exports", id: :serial, force: :cascade do |t|
    t.integer "owner_id", null: false
    t.string "file", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "download_token"
    t.string "job_id"
    t.boolean "downloaded", default: false, null: false
    t.string "owner_type"
  end

  create_table "global_invitations", force: :cascade do |t|
    t.string "token", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "owner_type"
    t.bigint "owner_id"
    t.json "payload", default: {}
    t.index ["owner_type", "owner_id"], name: "index_jobs_on_owner_type_and_owner_id"
  end

  create_table "join_requests", id: :serial, force: :cascade do |t|
    t.string "requestor_type", null: false
    t.integer "requestor_id", null: false
    t.integer "team_id", null: false
    t.datetime "accepted_at"
    t.datetime "declined_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "review_token"
    t.index ["requestor_type", "requestor_id"], name: "index_join_requests_on_requestor_type_and_requestor_id"
    t.index ["review_token"], name: "index_join_requests_on_review_token", unique: true
    t.index ["team_id"], name: "index_join_requests_on_team_id"
  end

  create_table "judge_assignments", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "assigned_judge_type"
    t.integer "assigned_judge_id"
    t.text "seasons", default: [], array: true
    t.index ["team_id"], name: "index_judge_assignments_on_team_id"
  end

  create_table "judge_profiles", id: :serial, force: :cascade do |t|
    t.integer "account_id"
    t.string "company_name", null: false
    t.string "job_title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "user_invitation_id"
    t.datetime "completed_training_at"
    t.integer "industry"
    t.string "industry_other"
    t.string "skills"
    t.string "degree"
    t.boolean "survey_completed"
    t.boolean "onboarded", default: false
    t.integer "quarterfinals_scores_count", default: 0, null: false
    t.integer "semifinals_scores_count", default: 0
    t.boolean "suspended", default: false
    t.index ["account_id"], name: "uniq_judges_accounts", unique: true, where: "(deleted_at IS NULL)"
    t.index ["user_invitation_id"], name: "index_judge_profiles_on_user_invitation_id"
  end

  create_table "judge_profiles_regional_pitch_events", id: false, force: :cascade do |t|
    t.integer "judge_profile_id"
    t.integer "regional_pitch_event_id"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.string "member_type", null: false
    t.integer "member_id", null: false
    t.integer "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_type", "member_id"], name: "index_memberships_on_member_type_and_member_id"
    t.index ["team_id"], name: "index_memberships_on_team_id"
  end

  create_table "mentor_profile_expertises", id: :serial, force: :cascade do |t|
    t.integer "mentor_profile_id"
    t.integer "expertise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "signup_attempt_id"
    t.index ["mentor_profile_id"], name: "index_mentor_profile_expertises_on_mentor_profile_id"
    t.index ["signup_attempt_id"], name: "index_mentor_profile_expertises_on_signup_attempt_id"
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
    t.bigint "user_invitation_id"
    t.integer "mentor_type"
    t.datetime "training_completed_at"
    t.index ["account_id"], name: "uniq_mentors_accounts", unique: true
    t.index ["user_invitation_id"], name: "index_mentor_profiles_on_user_invitation_id"
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
    t.string "regarding_type"
    t.integer "regarding_id"
    t.datetime "sent_at"
    t.datetime "delivered_at"
  end

  create_table "multi_messages", id: :serial, force: :cascade do |t|
    t.string "sender_type", null: false
    t.integer "sender_id", null: false
    t.string "regarding_type", null: false
    t.integer "regarding_id", null: false
    t.hstore "recipients", null: false
    t.string "subject"
    t.text "body", null: false
    t.datetime "sent_at"
    t.datetime "delivered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parental_consents", id: :serial, force: :cascade do |t|
    t.string "electronic_signature"
    t.integer "student_profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "newsletter_opt_in"
    t.text "seasons", default: [], array: true
    t.integer "status", default: 0, null: false
    t.index ["student_profile_id"], name: "index_parental_consents_on_student_profile_id"
  end

  create_table "pitch_presentations", id: :serial, force: :cascade do |t|
    t.string "uploaded_file"
    t.integer "team_submission_id", null: false
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
    t.text "intro_summary"
    t.string "secondary_regions", default: [], array: true
    t.string "program_name"
    t.index ["account_id"], name: "uniq_ambassadors_accounts", unique: true
    t.index ["status"], name: "index_regional_ambassador_profiles_on_status"
  end

  create_table "regional_links", force: :cascade do |t|
    t.bigint "regional_ambassador_profile_id"
    t.integer "name"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "custom_label"
    t.index ["regional_ambassador_profile_id"], name: "index_regional_links_on_regional_ambassador_profile_id"
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
    t.string "event_link"
    t.string "name"
    t.boolean "unofficial", default: false
    t.text "seasons", default: [], array: true
    t.integer "teams_count", default: 0
    t.integer "capacity"
    t.index ["division_id"], name: "index_regional_pitch_events_on_division_id"
  end

  create_table "regional_pitch_events_teams", id: false, force: :cascade do |t|
    t.integer "regional_pitch_event_id"
    t.integer "team_id"
    t.index ["regional_pitch_event_id", "team_id"], name: "pitch_events_teams", unique: true
    t.index ["team_id"], name: "pitch_events_team_ids"
  end

  create_table "regional_pitch_events_user_invitations", force: :cascade do |t|
    t.bigint "regional_pitch_event_id"
    t.bigint "user_invitation_id"
    t.index ["regional_pitch_event_id"], name: "events_invites_event_id"
    t.index ["user_invitation_id"], name: "events_invites_invite_id"
  end

  create_table "regions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.integer "requestor_id", null: false
    t.string "requestor_type", null: false
    t.integer "target_id", null: false
    t.string "target_type", null: false
    t.integer "request_type", null: false
    t.integer "request_status", default: 0, null: false
    t.json "requestor_meta"
    t.text "requestor_message"
    t.datetime "status_updated_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saved_searches", force: :cascade do |t|
    t.string "searcher_type", null: false
    t.bigint "searcher_id", null: false
    t.string "name", null: false
    t.string "search_string", null: false
    t.string "param_root", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searcher_type", "searcher_id"], name: "index_saved_searches_on_searcher_type_and_searcher_id"
  end

  create_table "screenshots", id: :serial, force: :cascade do |t|
    t.integer "team_submission_id"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_position", default: 0, null: false
    t.index ["team_submission_id"], name: "index_screenshots_on_team_submission_id"
  end

  create_table "signup_attempts", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "activation_token", null: false
    t.integer "account_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "signup_token"
    t.string "pending_token"
    t.string "password_digest"
    t.string "admin_permission_token"
    t.string "wizard_token"
    t.datetime "terms_agreed_at"
    t.integer "birth_year"
    t.integer "birth_month"
    t.integer "birth_day"
    t.string "first_name"
    t.string "last_name"
    t.integer "gender_identity"
    t.string "school_company_name"
    t.integer "referred_by"
    t.string "referred_by_other"
    t.string "city"
    t.string "state_code"
    t.string "country_code"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "profile_choice"
    t.string "job_title"
    t.integer "mentor_type"
    t.index ["status"], name: "index_signup_attempts_on_status"
  end

  create_table "student_profiles", id: :serial, force: :cascade do |t|
    t.integer "account_id"
    t.string "parent_guardian_email"
    t.string "parent_guardian_name"
    t.string "school_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "onboarded", default: false
    t.index ["account_id"], name: "uniq_students_accounts", unique: true
  end

  create_table "submission_scores", id: :serial, force: :cascade do |t|
    t.integer "team_submission_id"
    t.integer "judge_profile_id"
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
    t.text "seasons", default: [], array: true
    t.integer "ideation_comment_word_count", default: 0
    t.integer "technical_comment_word_count", default: 0
    t.integer "pitch_comment_word_count", default: 0
    t.integer "entrepreneurship_comment_word_count", default: 0
    t.integer "overall_comment_word_count", default: 0
    t.boolean "completed_too_fast", default: false
    t.boolean "completed_too_fast_repeat_offense", default: false
    t.boolean "seems_too_low", default: false
    t.datetime "approved_at"
    t.datetime "dropped_at"
    t.integer "ideation_1", default: 0
    t.integer "ideation_2", default: 0
    t.integer "ideation_3", default: 0
    t.integer "ideation_4", default: 0
    t.integer "technical_1", default: 0
    t.integer "technical_2", default: 0
    t.integer "technical_3", default: 0
    t.integer "technical_4", default: 0
    t.integer "pitch_1", default: 0
    t.integer "pitch_2", default: 0
    t.integer "entrepreneurship_1", default: 0
    t.integer "entrepreneurship_2", default: 0
    t.integer "entrepreneurship_3", default: 0
    t.integer "entrepreneurship_4", default: 0
    t.integer "overall_1", default: 0
    t.integer "overall_2", default: 0
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
    t.text "app_description"
    t.string "app_name"
    t.string "pitch_video_link"
    t.string "development_platform_other"
    t.integer "development_platform"
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
    t.datetime "deleted_at"
    t.integer "percent_complete", default: 0, null: false
    t.text "seasons", default: [], array: true
    t.string "app_inventor_app_name"
    t.string "app_inventor_gmail"
    t.datetime "published_at"
    t.string "business_plan"
    t.string "pitch_presentation"
    t.datetime "lowest_score_dropped_at"
    t.string "thunkable_account_email"
    t.string "thunkable_project_url"
    t.string "source_code_external_url"
    t.integer "quarterfinals_score_range", default: 0
    t.integer "semifinals_score_range", default: 0
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "division_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "team_photo"
    t.string "legacy_id"
    t.boolean "accepting_student_requests", default: true, null: false
    t.boolean "accepting_mentor_requests", default: true, null: false
    t.float "latitude"
    t.float "longitude"
    t.text "seasons", default: [], array: true
    t.string "city"
    t.string "state_province"
    t.string "country"
    t.datetime "deleted_at"
    t.boolean "has_students", default: false, null: false
    t.boolean "has_mentor", default: false, null: false
    t.boolean "all_students_onboarded", default: false
    t.index "name gist_trgm_ops", name: "trgm_team_name_indx", using: :gist
    t.index ["legacy_id"], name: "index_teams_on_legacy_id"
  end

  create_table "unconfirmed_email_addresses", force: :cascade do |t|
    t.string "email"
    t.bigint "account_id"
    t.string "confirmation_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_unconfirmed_email_addresses_on_account_id"
  end

  create_table "user_invitations", force: :cascade do |t|
    t.string "admin_permission_token", null: false
    t.string "email", null: false
    t.integer "account_id"
    t.integer "profile_type", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  add_foreign_key "accounts", "divisions"
  add_foreign_key "admin_profiles", "accounts"
  add_foreign_key "background_checks", "accounts"
  add_foreign_key "business_plans", "team_submissions"
  add_foreign_key "certificates", "accounts"
  add_foreign_key "certificates", "teams"
  add_foreign_key "consent_waivers", "accounts"
  add_foreign_key "divisions_regional_pitch_events", "divisions"
  add_foreign_key "divisions_regional_pitch_events", "regional_pitch_events"
  add_foreign_key "join_requests", "teams"
  add_foreign_key "judge_assignments", "teams"
  add_foreign_key "judge_profiles", "user_invitations"
  add_foreign_key "mentor_profile_expertises", "expertises"
  add_foreign_key "mentor_profile_expertises", "mentor_profiles"
  add_foreign_key "mentor_profile_expertises", "signup_attempts"
  add_foreign_key "mentor_profiles", "accounts"
  add_foreign_key "mentor_profiles", "user_invitations"
  add_foreign_key "parental_consents", "student_profiles"
  add_foreign_key "regional_links", "regional_ambassador_profiles"
  add_foreign_key "regional_pitch_events", "divisions"
  add_foreign_key "regional_pitch_events_teams", "regional_pitch_events"
  add_foreign_key "regional_pitch_events_teams", "teams"
  add_foreign_key "regional_pitch_events_user_invitations", "regional_pitch_events"
  add_foreign_key "regional_pitch_events_user_invitations", "user_invitations"
  add_foreign_key "screenshots", "team_submissions"
  add_foreign_key "signup_attempts", "accounts"
  add_foreign_key "submission_scores", "judge_profiles"
  add_foreign_key "submission_scores", "team_submissions"
  add_foreign_key "team_submissions", "teams"
  add_foreign_key "teams", "divisions"
  add_foreign_key "unconfirmed_email_addresses", "accounts"
end
