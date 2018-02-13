require 'sidekiq/web'
require 'admin_constraint'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new
  mount ActionCable.server => '/cable', constraints: AdminConstraint.new

  get '/sidekiq' => 'signins#new'

  resource :survey_completion, only: :show

  namespace :student do
    get :signup, to: 'signups#new'
    post :profiles, to: "signups#create"

    resource :location_details, only: :show

    resources :cookies, only: :create
    resource :survey_reminder, only: :create

    resource :dashboard, only: :show
    resource :profile, only: [:show, :edit, :update]

    resources :teams, except: :destroy
    resources :team_memberships, only: :destroy
    resources :team_locations, only: :edit
    resources :pending_teammates, only: :index

    resources :team_submissions
    resources :team_submission_sections, only: :show
    resources :team_submission_publications, only: :create
    resources :published_team_submissions, only: :show
    resource :honor_code_review, only: :show
    resource :published_submission_confirmation, only: :show
    resource :code_checklist, only: :update
    resources :screenshots, only: [:index, :create, :update, :destroy]
    resource :honor_code, only: :show
    resources :embed_codes, only: :show

    resource :team_photo_upload_confirmation, only: :show
    resource :profile_image_upload_confirmation, only: :show
    resource :team_submission_screenshot_upload_confirmation, only: :show
    resource :team_submission_file_upload_confirmation, only: :show

    resources :team_submission_pitch_presentations, only: [:new, :edit]

    resource :regional_pitch_event_selection,
      only: [:show, :create, :update, :destroy]

    resources :regional_pitch_events, only: :show
    resources :scores, only: [:show]

    resources :certificates, only: :create

    resources :image_process_jobs, only: :create
    resources :job_statuses, only: :show

    resources :mentors, only: :show
    resources :students, only: :show

    resources :team_member_invites, except: [:edit, :index]
    resources :mentor_invites, only: [:create, :destroy]
    resources :join_requests, only: [:new, :show, :create, :update]

    resources :team_searches, except: [:index, :destroy]
    resources :mentor_searches, except: [:index, :destroy]

    resource :parental_consent_notice, only: [:new, :create]
  end

  namespace :mentor do
    get :signup, to: 'signups#new'
    post :profiles, to: "signups#create"

    resource :location_details, only: :show

    resource :dashboard, only: :show
    resource :profile, only: [:show, :edit, :update]
    resource :bio, only: [:edit, :update]

    resources :cookies, only: :create
    resource :survey_reminder, only: :create

    resources :team_searches, except: [:index, :destroy]
    resources :mentor_searches, except: [:index, :destroy]

    resources :teams, except: [:index, :destroy]
    resources :team_memberships, only: :destroy
    resources :team_submissions
    resources :team_submission_sections, only: :show
    resources :team_submission_publications, only: :create
    resources :published_team_submissions, only: :show
    resource :honor_code_review, only: :show
    resource :published_submission_confirmation, only: :show
    resources :team_locations, only: :edit
    resources :pending_teammates, only: :index
    resource :honor_code, only: :show
    resources :embed_codes, only: :show

    resources :certificates, only: :create

    resource :code_checklist, only: :update
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

    resource :regional_pitch_event_selection,
      only: [:new, :show, :create, :update, :destroy]
    resources :regional_pitch_events, only: :show
    resources :scores, only: [:show]
  end

  get "pending_regional_ambassador/dashboard",
    to: "regional_ambassador/dashboards#show"

  namespace :regional_ambassador do
    get :signup, to: 'signups#new'
    post :profiles, to: "signups#create"

    resource :profile_details_confirmation, only: [:create, :update]

    resource :location_details, only: :show

    resource :dashboard, only: :show
    resource :profile, only: [:show, :edit, :update]

    resource :introduction, only: [:edit, :update]

    resources :job_statuses, only: :show

    resources :saved_searches, only: [:show, :create, :update, :destroy]

    resources :accounts, only: :show, controller: :participants
    resources :participants, only: [:index, :show, :edit, :update]
    resources :participant_sessions, only: [:show, :destroy]

    resource :missing_participant_search, only: [:new, :show, :create]
    resources :missing_participant_locations, only: [:edit, :update]

    resources :teams, only: [:show, :index]
    resources :team_submissions, only: [:index, :show]
    resources :team_memberships, only: [:create, :destroy]

    resources :activities, only: :index

    resources :export_downloads, only: :update

    resource :profile_image_upload_confirmation, only: :show

    resources :background_checks, only: [:new, :create, :show]

    resources :events, controller: :regional_pitch_events

    resources :regional_pitch_events

    resources :regional_pitch_event_participations,
      only: [:new, :create, :destroy]

    resources :judge_assignments, only: [:new, :create]
    resource :judge_assignments, only: :destroy

    resource :judge_search, only: :show
    resource :judge_list, only: :show

    resources :scores, only: [:index, :show]

    resources :messages
    resources :multi_messages
    resources :message_deliveries, only: :create
  end

  namespace :judge do
    get :signup, to: 'signups#new'
    post :profiles, to: "signups#create"

    resource :training_completion, only: :show

    resource :location_details, only: :show

    resource :profile, only: [:show, :edit, :update]

    resource :profile_image_upload_confirmation, only: :show

    resource :dashboard, only: :show

    resources :consent_waivers, only: [:new, :create, :show]
    resource :survey_answers, except: [:index, :destroy]
  end

  namespace :admin do
    resource :dashboard, only: :show

    resources :job_statuses, only: :show

    resources :saved_searches, only: [:show, :create, :update, :destroy]

    resources :participants
    resources :participant_sessions, only: [:show, :destroy]
    resources :user_invitations, only: [:new, :create, :index]
    resources :user_invitation_emails, only: :create

    resources :regional_ambassador_status, only: :update

    resources :profile_locations, only: :edit

    resources :teams, except: :destroy
    resources :team_submissions, except: :destroy
    resources :team_memberships, only: [:destroy, :create]
    resources :team_locations, only: :edit
    resources :team_submission_certificates, only: :update

    resources :background_checks, only: :index
    resources :background_check_sweeps, only: :create

    resources :regional_pitch_events, only: [:index, :show, :update]
    resources :regional_pitch_event_participations, only: :destroy

    resources :scores, only: [:index, :show]
    resources :semifinals_scores, only: [:index, :show]
    resources :submission_score_restorations, only: :update

    resource :mentor_drop_out, only: :create
    resource :paper_parental_consent, only: :create

    resources :export_downloads, only: :update

    resource :season_schedule_settings, only: [:edit, :update]
  end

  namespace :application do
    resource :dashboard, only: :show
  end

  resources :password_resets, only: [:new, :create]
  resources :passwords, only: [:new, :create]

  get "/parental_consents/edit", to: "parental_consents#edit"
  get "/parental_consents/new", to: "parental_consents#new"
  resource :parental_consent, only: [:new, :edit]
  resources :parental_consents, only: [:show, :update]

  resources :consent_waivers, only: [:new, :create, :show]

  resources :teams, only: :show
  resources :team_submission_pieces, only: :show

  resources :signup_attempts, only: [:create, :show, :update]
  resources :signup_attempt_confirmations, only: :new

  resources :email_confirmations, only: :new

  resource :locale_switch, only: :create

  resources :geolocation_results, only: :index

  get 'login', to: 'signins#new', as: :login
  get 'signin', to: 'signins#new', as: :signin

  get 'signup', to: 'signups#new', as: :signup

  match 'logout',
    to: 'signins#destroy',
    as: :logout,
    via: [:get, :delete]

  match 'signout',
    to: 'signins#destroy',
    as: :signout,
    via: [:get, :delete]

  resources :signins, only: :create

  resource :token_error, only: :show
  resource :timeout_error, only: :show

  root to: "application/dashboards#show"
end
