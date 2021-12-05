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
    resources :join_requests, only: [:new, :show, :create, :update, :destroy]

    resources :team_searches, except: [:index, :destroy]
    resources :mentor_searches, except: [:index, :destroy]

    resource :downloadable_parental_consent, only: :show
    resource :parental_consent_notice, only: [:new, :create]
  end

  namespace :mentor do
    get :signup, to: 'signups#new'
    post :profiles, to: "signups#create"

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

    resource :regional_pitch_events_team_list, only: :show
    resource :regional_pitch_event_selection, only: :create
    resources :regional_pitch_events, only: [:index, :show]
    resources :scores, only: :show
  end

  get "pending_chapter_ambassador/dashboard",
    to: "chapter_ambassador/dashboards#show"

  namespace :chapter_ambassador do
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

    resources :scores, only: [:index, :new, :update, :show] do
      patch :judge_recusal
    end

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

    resource :current_location, only: :show
    resource :location, only: [:update, :create]

    resources :saved_searches, only: [:show, :create, :update, :destroy]

    resources :participants do
      delete "permanently_delete"
    end

    resources :participant_sessions, only: [:show, :destroy]
    resources :user_invitations, only: [:new, :create, :index]
    resources :user_invitation_emails, only: :create

    resources :student_conversions, only: :create
    resources :mentor_to_judge_conversions, only: :create

    resources :chapter_ambassador_status, only: :update

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

    resources :score_details, only: :show
    resources :submission_score_restorations, only: :update

    resources :score_exports, only: [:index]

    resource :paper_parental_consent, only: :create

    resources :export_downloads, only: :update

    resource :season_schedule_settings, only: [:show, :edit, :update]

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
  resource :media_consent, only: [:show, :edit, :update]

  resources :teams, only: :show
  resources :team_submission_pieces, only: :show

  resources :signup_attempts, only: [:create, :show, :update]
  resources :signup_attempt_confirmations, only: :new

  resources :email_confirmations, only: :new

  resource :locale_switch, only: :create

  resources :geolocation_results, only: :index

  get "learnworlds", to: "learn_worlds#sso"

  get '/general_info/get_started_with_thunkable', to: 'thunkable#show'

  get 'login', to: 'signins#new', as: :login
  get 'signin', to: 'signins#new', as: :signin

  get 'signup', to: 'signups#new', as: :signup

  get '/new-registration', to: 'new_registration#show'
  post '/new-registration', to: 'new_registration#create'

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

  get "pending_regional_ambassador/dashboard",
    to: redirect("chapter_ambassador/dashboard", status: 301)

  get "regional_ambassador/signup",
    to: redirect("chapter_ambassador/signups", status: 301)

  post "/regional_ambassador/profiles",
    to: redirect("chapter_ambassador/signups", status: 308)

  patch "/regional_ambassador/profile_details_confirmation",
    to: redirect("chapter_ambassador/profile_details_confirmation", status: 308)

  put "/regional_ambassador/profile_details_confirmation",
    to: redirect("chapter_ambassador/profile_details_confirmation", status: 308)

  post "/regional_ambassador/profile_details_confirmation",
    to: redirect("chapter_ambassador/profile_details_confirmation", status: 308)

  get "/regional_ambassador/location_details",
    to: redirect("chapter_ambassador/location_details", status: 301)

  get "/regional_ambassador/current_location",
    to: redirect("chapter_ambassador/current_location", status: 301)

  patch "/regional_ambassador/location",
    to: redirect("chapter_ambassador/location", status: 308)

  put "/regional_ambassador/location",
    to: redirect("chapter_ambassador/location", status: 308)

  post "/regional_ambassador/location",
    to: redirect("chapter_ambassador/location", status: 308)

  get "/regional_ambassador/dashboard",
    to: redirect("chapter_ambassador/dashboard", status: 301)

  get "/regional_ambassador/data_analyses/:id",
    to: redirect("chapter_ambassador/data_analyses/%{id}", status: 301)

  get "/regional_ambassador/profile/edit",
    to: redirect("chapter_ambassador/profiles/edit", status: 301)

  get "/regional_ambassador/profile",
    to: redirect("chapter_ambassador/profile", status: 301)

  patch "/regional_ambassador/profile",
    to: redirect("chapter_ambassador/profile", status: 308)

  put "/regional_ambassador/profile",
    to: redirect("chapter_ambassador/profile", status: 308)

  get "/regional_ambassador/introduction/edit",
    to: redirect("chapter_ambassador/introduction/edit", status: 301)

  patch "/regional_ambassador/introduction",
     to: redirect("chapter_ambassador/introduction", status: 308)

  put "/regional_ambassador/introduction",
     to: redirect("chapter_ambassador/introduction", status: 308)

  get "/regional_ambassador/job_statuses/:id",
    to: redirect("chapter_ambassador/job_statuses/%{id}", status: 301)

  post "/regional_ambassador/saved_searches",
    to: redirect("chapter_ambassador/saved_searches", status: 308)

  get "/regional_ambassador/saved_searches/:id",
    to: redirect("chapter_ambassador/saved_searches/%{id}", status: 301)

  patch "/regional_ambassador/saved_searches/:id",
    to: redirect("chapter_ambassador/saved_searches/%{id}", status: 308)

  put "/regional_ambassador/saved_searches/:id",
    to: redirect("chapter_ambassador/saved_searches/%{id}", status: 308)

  delete "/regional_ambassador/saved_searches/:id",
    to: redirect("chapter_ambassador/saved_searches/%{id}", status: 308)

  get "/regional_ambassador/accounts/:id",
    to: redirect("chapter_ambassador/participants/%{id}", status: 301)

  get "/regional_ambassador/participants",
    to: redirect("chapter_ambassador/participants", status: 301)

  get "/regional_ambassador/participants/:id/edit",
    to: redirect("chapter_ambassador/participants/%{id}/edit", status: 301)

  get "/regional_ambassador/participants/:id",
    to: redirect("chapter_ambassador/participants/%{id}", status: 301)

  patch "/regional_ambassador/participants/:id",
    to: redirect("chapter_ambassador/participants/%{id}", status: 308)

  put "/regional_ambassador/participants/:id",
    to: redirect("chapter_ambassador/participants/%{id}", status: 308)

  get "/regional_ambassador/participant_sessions/:id",
    to: redirect("chapter_ambassador/participant_sessions/%{id}", status: 301)

  delete "/regional_ambassador/participant_sessions/:id",
    to: redirect("chapter_ambassador/participant_sessions/%{id}", status: 308)

  post "/regional_ambassador/student_conversions",
    to: redirect("chapter_ambassador/student_conversions", status: 308)

  post "/regional_ambassador/mentor_to_judge_conversions",
    to: redirect("chapter_ambassador/mentor_to_judge_conversions", status: 308)

  get "/regional_ambassador/missing_participant_search/new",
    to: redirect("chapter_ambassador/missing_participant_searches/new", status: 301)

  get "/regional_ambassador/missing_participant_search",
    to: redirect("chapter_ambassador/missing_participant_search", status: 301)

  post "/regional_ambassador/missing_participant_search",
    to: redirect("chapter_ambassador/missing_participant_search", status: 308)

  get "/regional_ambassador/missing_participant_locations/:id/edit",
    to: redirect("chapter_ambassador/missing_participant_locations/%{id}/edit", status: 301)

  patch "/regional_ambassador/missing_participant_locations/:id",
    to: redirect("chapter_ambassador/missing_participant_locations/%{id}", status: 308)

  put "/regional_ambassador/missing_participant_locations/:id",
    to: redirect("chapter_ambassador/missing_participant_locations/%{id}", status: 308)

  get "/regional_ambassador/teams",
    to: redirect("chapter_ambassador/teams", status: 301)

  get "/regional_ambassador/teams/:id",
    to: redirect("chapter_ambassador/teams/%{id}", status: 301)

  get "/regional_ambassador/team_submissions",
    to: redirect("chapter_ambassador/team_submissions", status: 301)

  get "/regional_ambassador/team_submissions/:id",
    to: redirect("chapter_ambassador/team_submissions/%{id}", status: 301)

  post "/regional_ambassador/team_memberships",
    to: redirect("chapter_ambassador/team_memberships", status: 308)

  delete "/regional_ambassador/team_memberships/:id",
    to: redirect("chapter_ambassador/team_memberships/%{id}", status: 308)

  get "/regional_ambassador/activities",
    to: redirect("chapter_ambassador/activities", status: 301)

  patch "/regional_ambassador/export_downloads/:id",
    to: redirect("chapter_ambassador/export_downloads/%{id}", status: 308)

  put "/regional_ambassador/export_downloads/:id",
    to: redirect("chapter_ambassador/export_downloads/%{id}", status: 308)

  get "/regional_ambassador/profile_image_upload_confirmation",
    to: redirect("chapter_ambassador/profile_image_upload_confirmation", status: 301)

  post "/regional_ambassador/background_checks",
    to: redirect("chapter_ambassador/background_checks", status: 308)

  get "/regional_ambassador/background_checks/new",
    to: redirect("chapter_ambassador/background_checks/new", status: 301)

  get "/regional_ambassador/background_checks/:id",
    to: redirect("chapter_ambassador/background_checks/%{id}", status: 301)

  get "/regional_ambassador/events",
    to: redirect("chapter_ambassador/regional_pitch_events", status: 301)

  post "/regional_ambassador/events",
    to: redirect("chapter_ambassador/regional_pitch_events", status: 308)

  get "/regional_ambassador/events/new",
    to: redirect("chapter_ambassador/regional_pitch_events/new", status: 301)

  get "/regional_ambassador/events/:id/edit",
    to: redirect("chapter_ambassador/regional_pitch_events/%{id}/edit", status: 301)

  get "/regional_ambassador/events/:id",
    to: redirect("chapter_ambassador/regional_pitch_events/%{id}", status: 301)

  patch "/regional_ambassador/events/:id",
    to: redirect("chapter_ambassador/regional_pitch_events/%{id}", status: 308)

  put "/regional_ambassador/events/:id",
    to: redirect("chapter_ambassador/regional_pitch_events/%{id}", status: 308)

  delete "/regional_ambassador/events/:id",
    to: redirect("chapter_ambassador/regional_pitch_events/%{id}", status: 308)

  get "/regional_ambassador/regional_pitch_events",
    to: redirect("chapter_ambassador/regional_pitch_events", status: 301)

  post "/regional_ambassador/regional_pitch_events",
    to: redirect("chapter_ambassador/regional_pitch_events", status: 308)

  get "/regional_ambassador/regional_pitch_events/new",
    to: redirect("chapter_ambassador/regional_pitch_events/new", status: 301)

  get "/regional_ambassador/regional_pitch_events/:id/edit",
    to: redirect("chapter_ambassador/regional_pitch_events/%{id}/edit", status: 301)

  get "/regional_ambassador/regional_pitch_events/:id",
    to: redirect("chapter_ambassador/regional_pitch_events/%{id}", status: 301)

  patch "/regional_ambassador/regional_pitch_events/:id",
    to: redirect("chapter_ambassador/regional_pitch_events/%{id}", status: 308)

  put "/regional_ambassador/regional_pitch_events/:id",
    to: redirect("chapter_ambassador/regional_pitch_events/%{id}", status: 308)

  delete "/regional_ambassador/regional_pitch_events/:id",
    to: redirect("chapter_ambassador/regional_pitch_events/%{id}", status: 308)

  get "/regional_ambassador/printable_scores/:id",
    to: redirect("chapter_ambassador/printable_scores/%{id}", status: 301)

  post "/regional_ambassador/event_team_list_exports",
    to: redirect("chapter_ambassador/event_team_list_exports", status: 308)

  post "/regional_ambassador/event_judge_list_exports",
    to: redirect("chapter_ambassador/event_judge_list_exports", status: 308)

  delete "/regional_ambassador/judge_assignments",
    to: redirect("chapter_ambassador/judge_assignments", status: 308)

  post "/regional_ambassador/judge_assignments",
    to: redirect("chapter_ambassador/judge_assignments", status: 308)

  post "/regional_ambassador/event_assignments",
    to: redirect("chapter_ambassador/event_assignments", status: 308)

  delete "/regional_ambassador/event_assignments",
    to: redirect("chapter_ambassador/event_assignments", status: 308)

  get "/regional_ambassador/possible_event_attendees",
    to: redirect("chapter_ambassador/possible_event_attendees", status: 301)

  get "/regional_ambassador/judge_list",
    to: redirect("chapter_ambassador/judge_list", status: 301)

  get "/regional_ambassador/team_list",
    to: redirect("chapter_ambassador/team_list", status: 301)

  get "/regional_ambassador/scores",
    to: redirect("chapter_ambassador/scores", status: 301)

  get "/regional_ambassador/scores/:id",
    to: redirect("chapter_ambassador/scores/%{id}", status: 301)

  get "/regional_ambassador/score_details/:id",
    to: redirect("chapter_ambassador/score_details/%{id}", status: 301)

  get "/regional_ambassador/judges",
    to: redirect("chapter_ambassador/judges", status: 301)

  get "/regional_ambassador/messages",
    to: redirect("chapter_ambassador/messages", status: 301)

  post "/regional_ambassador/messages",
    to: redirect("chapter_ambassador/messages", status: 308)

  get "/regional_ambassador/messages/new",
    to: redirect("chapter_ambassador/messages/new", status: 301)

  get "/regional_ambassador/messages/:id/edit",
    to: redirect("chapter_ambassador/messages/%{id}/edit", status: 301)

  get "/regional_ambassador/messages/:id",
    to: redirect("chapter_ambassador/messages/%{id}", status: 301)

  patch "/regional_ambassador/messages/:id",
    to: redirect("chapter_ambassador/messages/%{id}", status: 308)

  put "/regional_ambassador/messages/:id",
    to: redirect("chapter_ambassador/messages/%{id}", status: 308)

  delete "/regional_ambassador/messages/:id",
    to: redirect("chapter_ambassador/messages/%{id}", status: 308)

  get "/regional_ambassador/multi_messages",
    to: redirect("chapter_ambassador/multi_messages", status: 301)

  post "/regional_ambassador/multi_messages",
    to: redirect("chapter_ambassador/multi_messages", status: 308)

  get "/regional_ambassador/multi_messages/new",
    to: redirect("chapter_ambassador/multi_messages/new", status: 301)

  get "/regional_ambassador/multi_messages/:id/edit",
    to: redirect("chapter_ambassador/multi_messages/%{id}/edit", status: 301)

  get "/regional_ambassador/multi_messages/:id",
    to: redirect("chapter_ambassador/multi_messages/%{id}", status: 301)

  patch "/regional_ambassador/multi_messages/:id",
    to: redirect("chapter_ambassador/multi_messages/%{id}", status: 308)

  put "/regional_ambassador/multi_messages/:id",
    to: redirect("chapter_ambassador/multi_messages/%{id}", status: 308)

  delete "/regional_ambassador/multi_messages/:id",
    to: redirect("chapter_ambassador/multi_messages/%{id}", status: 308)

  post "/regional_ambassador/message_deliveries",
    to: redirect("chapter_ambassador/message_deliveries", status: 308)
end
