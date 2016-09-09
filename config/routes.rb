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

    resources :mentors, only: :show
    resources :students, only: :show

    resources :team_member_invites, except: [:edit, :index]
    resources :mentor_invites, only: [:create, :destroy]
    resources :join_requests, only: [:new, :create, :update]

    resources :team_searches, except: [:index, :destroy]
    resources :mentor_searches, except: [:index, :destroy]

    resource :parental_consent_notice, only: :create
  end

  namespace :mentor do
    get :signup, to: 'signups#new'
    post :accounts, to: "signups#create"

    resource :dashboard, only: :show
    resource :account, only: [:show, :edit, :update]

    resources :team_searches, except: [:index, :destroy]
    resources :teams, except: :destroy
    resources :team_memberships, only: :destroy

    resources :team_member_invites, except: [:edit, :index]
    resources :join_requests, except: :edit
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

    resources :background_checks, only: [:new, :create, :show]
    resources :teams, only: [:index]
  end

  namespace :judge do
    get :signup, to: 'signups#new'
    post :accounts, to: "signups#create"

    resource :dashboard, only: :show

    resources :scores, only: :index

    resources :submissions, only: [] do
      resources :scores
    end
  end

  namespace :admin do
    resources :score_categories
    resources :pending_regional_ambassadors, only: [:index, :update]
    resources :regional_ambassadors, only: :show
    resource :dashboard, only: :show
  end

  namespace :application do
    resource :dashboard, only: :show
  end

  resources :password_resets, only: [:new, :create]
  resources :passwords, only: [:new, :create]

  resources :parental_consents, only: [:new, :create, :show]
  resources :consent_waivers, only: [:new, :create, :show]

  resources :teams, only: :show

  get 'login', to: 'signins#new', as: :login
  get 'signin', to: 'signins#new', as: :signin

  get 'signup', to: 'signups#new', as: :signup

  match 'logout',  to: 'signins#destroy', as: :logout, via: [:get, :delete]
  match 'signout', to: 'signins#destroy', as: :signout, via: [:get, :delete]

  resources :signins, only: :create

  root to: "application/dashboards#show"
end
