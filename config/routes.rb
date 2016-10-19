require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :student do
    get :signup, to: 'signups#new'
    post :accounts, to: "signups#create"

    resource :dashboard, only: :show
    resource :account, only: [:show, :edit, :update]

    resources :teams, except: :delete
    resources :team_memberships, only: :destroy

    resources :team_submissions

    resource :team_photo_upload_confirmation, only: :show
    resource :profile_image_upload_confirmation, only: :show
    resource :team_submission_screenshot_upload_confirmation, only: :show

    resources :mentors, only: :show
    resources :students, only: :show

    resources :team_member_invites, except: [:edit, :index]
    resources :mentor_invites, only: [:create, :destroy]
    resources :join_requests, only: [:new, :create, :update]

    resources :team_searches, except: [:index, :destroy]
    resources :mentor_searches, except: [:index, :destroy]

    resource :parental_consent_notice, only: [:new, :create]
    resources :errors, only: :index
  end

  namespace :mentor do
    get :signup, to: 'signups#new'
    post :accounts, to: "signups#create"

    resource :dashboard, only: :show
    resource :account, only: [:show, :edit, :update]

    resources :team_searches, except: [:index, :destroy]
    resources :mentor_searches, except: [:index, :destroy]

    resources :teams, except: :destroy
    resources :team_memberships, only: :destroy

    resource :team_photo_upload_confirmation, only: :show
    resource :profile_image_upload_confirmation, only: :show

    resources :team_member_invites, except: [:edit, :index]
    resources :join_requests, except: [:index, :edit]
    resources :mentor_invites, only: [:show, :update, :destroy]

    resources :mentors, only: :show
    resources :students, only: :show

    resources :background_checks, only: [:new, :create, :show]
  end

  namespace :regional_ambassador do
    get :signup, to: 'signups#new'
    post :accounts, to: "signups#create"

    resource :dashboard, only: :show
    resource :account, only: [:show, :edit, :update]

    resources :accounts, only: :index
    resources :teams, only: [:show, :index]

    resources :exports, only: :create

    resource :profile_image_upload_confirmation, only: :show

    resources :background_checks, only: [:new, :create, :show]
  end

  namespace :judge do
    get :signup, to: 'signups#new'
    post :accounts, to: "signups#create"

    resource :account, only: [:show, :edit, :update]

    resource :profile_image_upload_confirmation, only: :show

    resource :dashboard, only: :show
  end

  namespace :admin do
    resource :dashboard, only: :show

    resources :accounts
    resources :regional_ambassadors, only: [:index, :show, :update]
    resources :teams, except: :destroy

    resources :background_checks, only: :index
    resources :background_check_sweeps, only: :create

    resources :signup_attempts, only: :index

    resource :mentor_drop_out, only: :create
    resource :paper_parental_consent, only: :create

    resources :exports, only: :create
  end

  namespace :application do
    resource :dashboard, only: :show
  end

  resources :password_resets, only: [:new, :create]
  resources :passwords, only: [:new, :create]

  resources :parental_consents, only: [:new, :create, :show]
  resources :consent_waivers, only: [:new, :create, :show]

  resources :teams, only: :show

  resources :signup_attempts, only: [:create, :show, :update]
  resources :signup_attempt_confirmations, only: :new

  get 'login', to: 'signins#new', as: :login
  get 'signin', to: 'signins#new', as: :signin

  get 'signup', to: 'signups#new', as: :signup

  match 'logout',  to: 'signins#destroy', as: :logout, via: [:get, :delete]
  match 'signout', to: 'signins#destroy', as: :signout, via: [:get, :delete]

  resources :signins, only: :create

  root to: "application/dashboards#show"
end
