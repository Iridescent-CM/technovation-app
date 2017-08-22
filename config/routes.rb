require 'sidekiq/web'
require 'admin_constraint'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new
  get '/sidekiq' => 'signins#new'

  namespace :student do
    get :signup, to: 'signups#new'
    post :profiles, to: "signups#create"

    resource :location_details, only: :show

    resources :cookies, only: :create

    resource :dashboard, only: :show
    resource :profile, only: [:show, :edit, :update]

    resources :teams, except: :destroy
    resources :team_memberships, only: :destroy
    resources :team_locations, only: :edit

    resources :team_submissions
    resource :technical_checklist, only: [:edit, :update]
    resources :screenshots, only: [:index, :destroy]

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
    resources :join_requests, only: [:new, :create, :update]

    resources :team_searches, except: [:index, :destroy]
    resources :mentor_searches, except: [:index, :destroy]

    resource :parental_consent_notice, only: [:new, :create]
    resources :honor_code_agreements, only: [:new, :create]
    resource :honor_code_agreement, only: :show
  end

  namespace :mentor do
    get :signup, to: 'signups#new'
    post :profiles, to: "signups#create"

    resource :location_details, only: :show

    resource :dashboard, only: :show
    resource :profile, only: [:show, :edit, :update]
    resource :bio, only: [:edit, :update]

    resources :cookies, only: :create

    resources :team_searches, except: [:index, :destroy]
    resources :mentor_searches, except: [:index, :destroy]

    resources :teams, except: :destroy
    resources :team_memberships, only: :destroy
    resources :team_submissions
    resources :team_locations, only: :edit

    resources :certificates, only: :create

    resource :technical_checklist, only: [:edit, :update]
    resources :screenshots, only: [:index, :destroy]

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
    resources :honor_code_agreements, only: [:new, :create]
    resource :honor_code_agreement, only: :show

    resource :regional_pitch_event_selection, only: [:new, :show, :create, :update, :destroy]
    resources :regional_pitch_events, only: :show
    resources :scores, only: [:show]
  end

  namespace :regional_ambassador do
    get :signup, to: 'signups#new'
    post :profiles, to: "signups#create"

    resource :location_details, only: :show

    resource :dashboard, only: :show
    resource :profile, only: [:show, :edit, :update]
    resource :account, only: :update

    resources :profiles, only: :index
    resources :users, only: :show
    resources :teams, only: [:show, :index]
    resources :team_submissions, only: [:index, :show]
    resources :team_memberships, only: :destroy

    resources :exports, only: :create

    resource :profile_image_upload_confirmation, only: :show

    resources :background_checks, only: [:new, :create, :show]

    resources :regional_pitch_events
    resources :regional_pitch_event_participations, only: [:new, :create, :destroy]
    resources :judge_assignments, only: [:new, :create, :destroy]

    resources :scores, only: [:index, :show]

    resources :messages
    resources :multi_messages
    resources :message_deliveries, only: :create
  end

  namespace :judge do
    get :signup, to: 'signups#new'
    post :profiles, to: "signups#create"

    resource :location_details, only: :show

    resource :profile, only: [:show, :edit, :update]

    resource :profile_image_upload_confirmation, only: :show

    resource :dashboard, only: :show

    resource :mentor_profile

    resources :submission_scores, only: [:new, :edit, :update]

    resources :team_submissions, only: [] do
      resources :technical_checklist_verifications, only: [:new, :create]
    end

    resource :regional_pitch_event_selection, only: [:show, :create, :update, :destroy]
    resources :regional_pitch_events, only: :show
  end

  namespace :admin do
    resource :dashboard, only: :show

    resources :profiles
    resources :profile_locations, only: :edit
    resources :regional_ambassadors, only: [:index, :show, :update]

    resources :teams, except: :destroy
    resources :team_submissions, except: :destroy
    resources :team_memberships, only: [:destroy, :create]
    resources :team_locations, only: :edit
    resources :team_submission_certificates, only: :update

    resources :background_checks, only: :index
    resources :background_check_sweeps, only: :create

    resources :signup_attempts, only: :index
    resources :signup_invitations, only: :create

    resources :regional_pitch_events, only: [:index, :show, :update]
    resources :regional_pitch_event_participations, only: :destroy

    resources :scores, only: [:index, :show]
    resources :semifinals_scores, only: [:index, :show]
    resources :submission_score_restorations, only: :update


    resource :mentor_drop_out, only: :create
    resource :paper_parental_consent, only: :create

    resources :exports, only: :create

    resource :season_schedule_settings, only: [:edit, :update]
  end

  namespace :application do
    resource :dashboard, only: :show
  end

  resources :interruptions, only: :index

  resources :password_resets, only: [:new, :create]
  resources :passwords, only: [:new, :create]

  resources :parental_consents, only: [:new, :create, :show]
  resources :consent_waivers, only: [:new, :create, :show]

  resources :teams, only: :show
  resources :apps, controller: :team_submissions, only: :show
  resources :technical_checklists, only: :show

  resources :signup_attempts, only: [:create, :show, :update]
  resources :signup_attempt_confirmations, only: :new

  resources :email_confirmations, only: :new

  resource :locale_switch, only: :create

  resources :geolocation_results, only: :index

  get 'login', to: 'signins#new', as: :login
  get 'signin', to: 'signins#new', as: :signin

  get 'signup', to: 'signups#new', as: :signup

  match 'logout',  to: 'signins#destroy', as: :logout, via: [:get, :delete]
  match 'signout', to: 'signins#destroy', as: :signout, via: [:get, :delete]

  resources :signins, only: :create

  resource :token_error, only: :show
  resource :timeout_error, only: :show

  root to: "application/dashboards#show"
end
