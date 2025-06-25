require "sidekiq/web"
require "admin_constraint"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq", :constraints => AdminConstraint.new
  mount ActionCable.server => "/cable", :constraints => AdminConstraint.new

  get "/sidekiq" => "signins#new"

  resource :survey_completion, only: :show

  namespace :student do
    resource :location_details, only: :show
    resource :current_location, only: :show
    resource :location, only: [:update, :create]

    resources :cookies, only: :create
    resource :survey_reminder, only: :create

    resource :dashboard, only: :show
    resource :profile, only: [:show, :edit, :update]
    resource :basic_profile, only: :update

    resources :teams, except: :destroy
    resources :team_memberships, only: :destroy
    resources :team_locations, only: :edit
    resources :pending_teammates, only: :index

    resources :team_submissions
    resources :team_submission_sections, only: :show
    resources :team_submission_video_link_reviews, only: [:new, :update]
    resources :team_submission_publications, only: :create
    resources :published_team_submissions, only: :show
    resource :honor_code_review, only: :show
    resource :published_submission_confirmation, only: :show

    resources :screenshots, only: [:index, :create, :update, :destroy]
    resource :honor_code, only: :show
    resources :embed_codes, only: :show

    resource :team_photo_upload_confirmation, only: :show
    resource :profile_image_upload_confirmation, only: :show
    resource :team_submission_screenshot_upload_confirmation, only: :show
    resource :team_submission_file_upload_confirmation, only: :show

    resources :team_submission_pitch_presentations, only: [:new, :edit]

    resource :regional_pitch_event_selection, only: :create

    resources :regional_pitch_events, only: [:show, :index]
    resources :scores, only: [:index, :show]

    resources :image_process_jobs, only: :create
    resources :job_statuses, only: :show

    resources :mentors, only: :show
    resources :students, only: :show
    resource :mentor_conversion, only: [:show, :create]

    resources :team_member_invites, except: [:edit]
    resources :mentor_invites, only: [:create, :destroy]
    resources :join_requests, only: [:new, :show, :create, :update, :destroy]

    resources :team_searches, except: [:index, :destroy]
    resources :mentor_searches, except: [:index, :destroy]

    resource :downloadable_parental_consent, only: :show
    resource :parental_consent_notice, only: [:new, :create]
    resource :paper_consent_upload, only: [:update]
  end

  namespace :mentor do
    resource :location_details, only: :show
    resource :current_location, only: :show
    resource :location, only: [:update, :create]
    resource :training_completion, only: :show
    resources :consent_waivers, only: [:new, :create, :show]

    resource :dashboard, only: :show
    resource :profile, only: [:show, :edit, :update]
    resource :basic_profile, only: :update
    resource :bio, only: [:edit, :update]

    resources :cookies, only: :create
    resource :survey_reminder, only: :create

    resources :team_searches, except: [:index, :destroy]
    resources :mentor_searches, except: [:index, :destroy]

    resources :teams, except: [:index, :destroy]
    resources :team_memberships, only: :destroy

    resources :team_submissions
    resources :team_submission_sections, only: :show
    resources :team_submission_video_link_reviews, only: [:new, :update]
    resources :team_submission_publications, only: :create
    resources :published_team_submissions, only: :show
    resource :honor_code_review, only: :show
    resource :published_submission_confirmation, only: :show

    resources :team_locations, only: :edit
    resources :pending_teammates, only: :index
    resource :honor_code, only: :show
    resources :embed_codes, only: :show

    resources :screenshots, only: [:index, :create, :update, :destroy]

    resource :team_photo_upload_confirmation, only: :show
    resource :profile_image_upload_confirmation, only: :show

    resource :team_submission_screenshot_upload_confirmation, only: :show
    resource :team_submission_file_upload_confirmation, only: :show

    resources :team_submission_pitch_presentations, only: [:new, :edit]

    resources :image_process_jobs, only: :create
    resources :job_statuses, only: :show

    resources :team_member_invites, except: [:edit, :index]
    resources :join_requests, except: [:index, :edit]
    resources :mentor_invites, only: [:show, :update, :destroy]

    resources :mentors, only: :show
    resources :students, only: :show

    resources :background_checks, only: [:new, :create, :show]

    post "/background_check_invitation", to: "background_checks#create_invitation"

    resource :regional_pitch_events_team_list, only: :show
    resource :regional_pitch_event_selection, only: :create
    resources :regional_pitch_events, only: [:index, :show]
    resources :scores, only: :show
  end

  namespace :ambassador do
    resources :accounts, only: [] do
      resource :chapterable_account_assignments, only: [:create]
    end
  end

  namespace :chapter_ambassador do
    resource :profile_details_confirmation, only: [:create, :update]

    resource :current_location, only: :show
    resource :location, only: [:update, :create]
    resource :location_details, only: :show

    resource :chapter_admin, only: :show, controller: "chapter_admin"
    resource :dashboard, only: :show
    resources :data_analyses, only: :show
    resource :profile, only: [:show, :edit, :update]

    resource :chapter_profile, only: :show, controller: "chapter_profile"
    resource :chapter_affiliation_agreement, only: :show
    resource :public_information, only: [:show, :edit, :update], controller: "public_information"
    resource :chapter_organization_headquarters_location, only: [:edit, :update]
    resource :chapter_location, only: [:show, :edit, :update, :create], controller: "chapter_locations"
    resource :chapter_current_location, only: :show

    resource :chapter_program_information, only: [:show, :edit, :update, :new, :create], controller: "chapter_program_information"
    resource :chapter_volunteer_agreement, only: [:show, :create]
    resource :community_connections, only: [:show, :new, :create, :edit, :update]

    resources :job_statuses, only: :show

    resources :saved_searches, only: [:show, :create, :update, :destroy]

    resources :accounts, only: :show, controller: :participants
    resources :participants, only: :show, controller: "/ambassador/participants"
    resources :participants, only: :index, controller: "/data_grids/ambassador/participants"
    resources :scores, only: :index, controller: "/data_grids/ambassador/scores"
    resources :scores, only: :show, controller: "/ambassador/scores"
    resources :score_details, only: :show, controller: "/ambassador/score_details"
    resources :unaffiliated_participants, only: :index, controller: "/data_grids/ambassador/unaffiliated_participants"
    resources :participant_sessions, only: [:show, :destroy]

    resources :student_conversions, only: :create
    resources :mentor_to_judge_conversions, only: :create

    resource :missing_participant_search, only: [:new, :show, :create]
    resources :missing_participant_locations, only: [:edit, :update]

    resources :teams, only: :show, controller: "/ambassador/teams"
    resources :teams, only: :index, controller: "/data_grids/ambassador/teams"
    resources :team_submissions, only: :show, controller: "/ambassador/team_submissions"
    resources :team_submissions, only: :index, controller: "/data_grids/ambassador/team_submissions"
    resources :team_memberships, only: [:create, :destroy], controller: "/ambassador/team_memberships"
    resources :team_member_invites, only: [:destroy], controller: "/ambassador/team_member_invites"

    resources :activities, only: :index

    resources :export_downloads, only: :update

    resource :profile_image_upload_confirmation, only: :show

    resource :background_check, only: :show
    resources :background_checks, only: [:new, :create]
    post "/background_check_invitation", to: "background_checks#create_invitation"

    resources :trainings, only: :index
    resource :training_completion, only: :show

    resources :events, controller: :regional_pitch_events do
      get :bulk_download_submission_pitch_presentations
    end
    get "events_list", to: "/data_grids/ambassador/events#index", as: "events_list"

    resources :regional_pitch_events
    resources :printable_scores, only: :show
    resources :event_team_list_exports, only: :create
    resources :event_judge_list_exports, only: :create

    resource :judge_assignments, only: [:create, :destroy]
    resources :event_assignments, only: :create
    resource :event_assignments, only: :destroy
    resources :possible_event_attendees, only: :index

    resource :judge_list, only: :show
    resource :team_list, only: :show

    resources :judges, only: :index

    resources :messages
    resources :multi_messages
    resources :message_deliveries, only: :create
  end

  namespace :club_ambassador do
    resource :dashboard, only: :show
    resource :profile, only: [:show, :edit, :update]

    resource :current_location, only: :show
    resource :location, only: [:update, :create]
    resource :location_details, only: :show

    resource :club_profile, only: :show, controller: "club_profile"
    resource :club_headquarters_location, only: [:edit, :update]
    resource :club_location, only: [:show, :edit, :update, :create], controller: "club_locations"
    resource :club_current_location, only: :show

    resource :public_information, only: [:show, :edit, :update], controller: "club_public_information"

    resource :club_admin, only: :show, controller: "club_admin"
    resource :resources, only: :show

    resources :participants, only: :show, controller: "/ambassador/participants"
    resources :participants, only: :index, controller: "/data_grids/ambassador/participants"
    resources :scores, only: :index, controller: "/data_grids/ambassador/scores"
    resources :scores, only: :show, controller: "/ambassador/scores"
    resources :score_details, only: :show, controller: "/ambassador/score_details"
    resources :unaffiliated_participants, only: :index, controller: "/data_grids/ambassador/unaffiliated_participants"

    resources :teams, only: :show, controller: "/ambassador/teams"
    resources :teams, only: :index, controller: "/data_grids/ambassador/teams"
    resources :team_memberships, only: [:create, :destroy], controller: "/ambassador/team_memberships"
    resources :team_submissions, only: :show, controller: "/ambassador/team_submissions"
    resources :team_submissions, only: :index, controller: "/data_grids/ambassador/team_submissions"
    resources :team_member_invites, only: [:destroy], controller: "/ambassador/team_member_invites"

    resources :saved_searches, only: [:show, :create, :update, :destroy]
    resources :export_downloads, only: :update
  end

  namespace :judge do
    resource :training_completion, only: :show

    resource :location_details, only: :show
    resource :current_location, only: :show
    resource :location, only: [:update, :create]

    resource :profile, only: [:show, :edit, :update]

    resource :profile_image_upload_confirmation, only: :show

    resource :dashboard, only: :show

    resources :consent_waivers, only: [:new, :create, :show]
    resource :survey_answers, except: [:index, :destroy, :show]

    resources :regional_pitch_events, only: :show

    resources :scores, only: [:index, :new, :update, :show] do
      patch :judge_recusal
    end

    resources :score_completions, only: :create
    resources :finished_scores, only: :show
    resources :embed_codes, only: :show
  end

  namespace :admin do
    root to: "dashboards#show"
    resource :dashboard, only: :show

    resources :data_analyses, only: :show

    resources :admins do
      patch :make_super_admin
    end

    get :signup, to: "signups#new"
    patch :signups, to: "signups#update"

    resources :job_statuses, only: :show

    resource :current_location, only: :show
    resource :location, only: [:update, :create]

    resources :saved_searches, only: [:show, :create, :update, :destroy]

    resources :participants do
      delete "permanently_delete"
      resource :background_check_exemption, only: [] do
        patch :grant
        patch :revoke
      end
    end

    resources :unaffiliated_participants, only: [:index]
    resources :participant_sessions, only: [:show, :destroy]
    resources :user_invitations, only: [:new, :create, :index, :destroy]
    resources :user_invitation_emails, only: :create

    resources :student_conversions, only: :create
    resources :mentor_to_judge_conversions, only: :create
    resources :chapter_ambassador_profile_additions, only: :create
    resources :club_ambassador_profile_additions, only: :create

    resources :accounts, only: [] do
      resources :chapterable_account_assignments, only: [:new, :create, :edit, :update]
    end
    resources :chapters do
      resource :legal_contact, only: [:new, :create, :edit, :update], controller: "chapters/legal_contacts"
      resource :affiliation_agreement, only: :create, controller: "chapter_affiliation_agreement" do
        patch :void
      end
      resource :off_platform_affiliation_agreement,
        only: :create,
        controller: "chapters/off_platform_chapter_affiliation_agreement"
      resources :invites, only: :create, controller: "chapter_invites"
      resource :chapter_program_information, only: :show, controller: "chapters/chapter_program_information"
      resource :location, only: :edit, controller: "chapters/locations"
      resource :status, only: [], controller: "chapters/status" do
        patch :activate
        patch :deactivate
      end
    end

    resources :clubs do
      resource :location, only: :edit, controller: "clubs/locations"
      resource :status, only: [], controller: "clubs/status" do
        patch :activate
        patch :deactivate
      end
    end

    resources :club_ambassadors, only: :index

    resources :chapter_ambassadors, only: :index do
      resource :off_platform_chapter_volunteer_agreement,
        only: :create,
        controller: "chapter_ambassadors/off_platform_chapter_volunteer_agreement"
    end

    resources :chapter_ambassador_status, only: :update

    resources :profile_locations, only: :edit

    resources :teams, except: :destroy
    resources :team_submissions, except: :destroy do
      resource :judge_assignments, only: :create
      resources :screenshots, only: [:new, :create]
      patch :publish
      patch :unpublish
      patch :return_to_judging_pool

      collection do
        get :bulk_publish
        patch :bulk_publish
      end
    end

    resources :team_memberships, only: [:destroy, :create]
    resources :team_locations, only: :edit
    resources :team_submission_certificates, only: :update
    resources :team_member_invites, only: [:destroy]

    resources :background_checks, only: :index
    resources :background_check_sweeps, only: :create
    resources :background_check_syncs, only: :create

    resources :legal_documents, only: :index do
      patch :void
    end

    resources :events,
      controller: :regional_pitch_events,
      only: [:index, :show, :edit, :update] do
        get :bulk_download_submission_pitch_presentations
      end

    resources :event_participations,
      controller: :regional_pitch_event_participations,
      only: :destroy

    resources :scores, only: [:index, :show, :destroy] do
      patch :restore
    end

    resources :score_approvals, only: :create
    resources :judges, only: :index do
      patch :suspend
      patch :unsuspend
    end

    resources :mentors, only: :index

    resources :score_details, only: :show
    resources :submission_score_restorations, only: :update

    resources :score_exports, only: [:index]

    resource :paper_parental_consent, only: :create
    resources :paper_parental_consents, only: [:index] do
      patch :approve
      patch :reject
    end

    resource :paper_media_consent, only: :create
    resources :paper_media_consents, only: [:index] do
      patch :approve
      patch :reject
    end

    resources :export_downloads, only: :update

    resource :season_schedule_settings, only: [:show, :edit, :update]

    resources :certificates, only: [:index, :show, :create, :destroy]

    get "/semifinalist_snippet", to: "semifinalist_snippet#show"
  end

  namespace :public do
    resource :dashboard, only: :show
    resources :embed_codes, only: :show
  end

  namespace :api do
    namespace :registration do
      resources :settings, only: :index

      resources :mentor_expertises, only: :index
      resources :mentor_types, only: :index

      resources :judge_types, only: :index

      resource :chapter_organization_name, only: :show
      resource :club_name, only: :show
      resource :user_invitation_email, only: :show
    end

    namespace :regional_pitch_events do
      resources :settings, only: :index
    end
  end

  namespace :webhooks do
    resource :docusign, only: :create, controller: "docusign"
  end

  resource :terms_agreement, only: [:edit, :update]
  resource :chapterable_account_assignments, only: [:new, :create]

  resources :password_resets, only: [:new, :create]
  resources :passwords, only: [:new, :create]

  get "/parental_consents/edit", to: "parental_consents#edit"
  get "/parental_consents/new", to: "parental_consents#new"
  resource :parental_consent, only: [:new, :edit]
  resources :parental_consents, only: [:show, :update]
  resource :media_consent, only: [:show, :edit, :update]

  resources :teams, only: :show
  resources :team_submission_pieces, only: :show

  resources :email_confirmations, only: :new

  resource :locale_switch, only: :create

  resources :geolocation_results, only: :index

  get "/general_info/get_started_with_thunkable", to: "thunkable#show"

  get "login", to: "signins#new", as: :login
  get "signin", to: "signins#new", as: :signin

  get "signup", to: "new_registration#show", as: :signup
  post "/new-registration", to: "new_registration#create"

  match "logout",
    to: "signins#destroy",
    as: :logout,
    via: [:get, :delete]

  match "signout",
    to: "signins#destroy",
    as: :signout,
    via: [:get, :delete]

  resources :signins, only: :create

  resource :token_error, only: :show
  resource :timeout_error, only: :show

  resources :projects, only: :show

  root to: "public/dashboards#show"
end
