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
    resources :scores, only: :index

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
    resource :current_location, only: :show
    resource :location, only: [:update, :create]
    resource :training_completion, only: :show

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

    resource :regional_pitch_events_team_list, only: :show
    resource :regional_pitch_event_selection, only: :create
    resources :regional_pitch_events, only: [:index, :show]
    resources :scores, only: :show
  end

  get "pending_regional_ambassador/dashboard",
    to: "regional_ambassador/dashboards#show"

  namespace :regional_ambassador do
    get :signup, to: 'signups#new'
    post :profiles, to: "signups#create"

    resource :profile_details_confirmation, only: [:create, :update]

    resource :location_details, only: :show
    resource :current_location, only: :show
    resource :location, only: [:update, :create]

    resource :dashboard, only: :show
    resources :data_analyses, only: :show
    resource :profile, only: [:show, :edit, :update]

    resource :introduction, only: [:edit, :update]

    resources :job_statuses, only: :show

    resources :saved_searches, only: [:show, :create, :update, :destroy]

    resources :accounts, only: :show, controller: :participants
    resources :participants, only: [:index, :show, :edit, :update]
    resources :participant_sessions, only: [:show, :destroy]

    resources :student_conversions, only: :create
    resources :mentor_to_judge_conversions, only: :create

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
    resources :printable_scores, only: :show
    resources :event_team_list_exports, only: :create
    resources :event_judge_list_exports, only: :create

    resource :judge_assignments, only: [:create, :destroy]
    resources :event_assignments, only: :create
    resource :event_assignments, only: :destroy
    resources :possible_event_attendees, only: :index

    resource :judge_list, only: :show
    resource :team_list, only: :show

    resources :scores, only: [:index, :show]
    resources :score_details, only: :show
    resources :judges, only: :index

    resources :messages
    resources :multi_messages
    resources :message_deliveries, only: :create
  end

  namespace :judge do
    get :signup, to: 'signups#new'
    post :profiles, to: "signups#create"

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

    resources :scores, only: [:index, :new, :update, :show]
    resources :assigned_submissions, only: :index
    resources :score_completions, only: :create
    resources :finished_scores, only: :show
    resources :embed_codes, only: :show
  end

  namespace :admin do
    root to: 'dashboards#show'
    resource :dashboard, only: :show

    resources :data_analyses, only: :show

    resources :admins
    get :signup, to: 'signups#new'
    patch :signups, to: 'signups#update'

    resources :job_statuses, only: :show

    resources :requests, only: [:index, :update]
    resource :current_location, only: :show
    resource :location, only: [:update, :create]

    resources :saved_searches, only: [:show, :create, :update, :destroy]

    resources :participants
    resources :participant_sessions, only: [:show, :destroy]
    resources :user_invitations, only: [:new, :create, :index]
    resources :user_invitation_emails, only: :create

    resources :student_conversions, only: :create
    resources :mentor_to_judge_conversions, only: :create

    resources :regional_ambassador_status, only: :update

    resources :profile_locations, only: :edit

    resources :teams, except: :destroy
    resources :team_submissions, except: :destroy do
      resource :judge_assignments, only: :create
    end
    resources :team_memberships, only: [:destroy, :create]
    resources :team_locations, only: :edit
    resources :team_submission_certificates, only: :update

    resources :background_checks, only: :index
    resources :background_check_sweeps, only: :create

    resources :events,
      controller: :regional_pitch_events,
      only: [:index, :show, :edit, :update]

    resources :event_participations,
      controller: :regional_pitch_event_participations,
      only: :destroy

    resources :scores, only: [:index, :show, :destroy] do
      patch :restore
    end

    resources :suspicious_scores, only: :index
    resources :score_approvals, only: :create
    resources :judges, only: :index do
      patch :suspend
      patch :unsuspend
    end
    resources :contest_rank_changes, only: :create

    resources :score_details, only: :show
    resources :submission_score_restorations, only: :update

    resources :score_exports, only: [:index]

    resource :paper_parental_consent, only: :create

    resources :export_downloads, only: :update

    resource :season_schedule_settings, only: [:edit, :update]

    resources :certificates, only: [:index, :show, :create, :destroy]

    get '/semifinalist_snippet', to: 'semifinalist_snippet#show'
  end

  namespace :public do
    resource :dashboard, only: :show
    resources :embed_codes, only: :show

    get '/email_validations/new' => 'email_validations#new'
  end

  namespace :registration do
    resource :terms_agreement, only: :create
    resource :age, only: :create
    resource :profile_choice, only: :create
    resource :current_location, only: :show
    resource :location, only: [:update, :create]
    resource :basic_profile, only: :create
    resource :email, only: :create
    resource :account, only: :create
    resources :top_companies, only: :index
    resources :expertises, only: :index
  end

  resource :terms_agreement, only: [:edit, :update]

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

  get '/general_info/get_started_with_thunkable', to: 'thunkable#show'

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

  resources :apps, only: :show

  root to: "public/dashboards#show"
end
