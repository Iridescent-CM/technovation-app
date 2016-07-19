Rails.application.routes.draw do
  namespace :student do
    get :signup, to: 'signups#new'
    post :accounts, to: "signups#create"

    resource :dashboard, only: :show

    namespace :mentors do
      resource :search, only: :show
    end

    resources :teams, except: :delete
    resources :team_member_invites, except: [:edit, :update, :destroy]
    resources :mentor_invites, except: [:edit, :update, :destroy]

    resource :account, only: [:show, :edit, :update]
  end

  namespace :mentor do
    get :signup, to: 'signups#new'
    post :accounts, to: "signups#create"

    resources :teams, only: [:index, :show]
    resource :dashboard, only: :show

    resources :invite_acceptances, only: :show
  end

  resources :teams, only: :show
  resources :team_member_invite_acceptances, only: :show

  namespace :admin do
    resources :score_categories

    root to: 'dashboards#index'
  end

  namespace :coach do
    get :signup, to: 'signups#new'
    post :accounts, to: "signups#create"

    resource :dashboard, only: :show
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

  resources :mentors, only: :show

  namespace :application do
    resource :dashboard, only: :show
  end

  namespace :regional_ambassador do
    get :signup, to: 'signups#new'
  end

  get 'login', to: 'signins#new', as: :login
  get 'signin', to: 'signins#new', as: :signin

  get 'signup', to: 'signups#new', as: :signup

  match 'logout',  to: 'signins#destroy', as: :logout, via: [:get, :delete]
  match 'signout', to: 'signins#destroy', as: :signout, via: [:get, :delete]

  resources :signins, only: :create
  post 'accounts', to: "signups#create"

  root to: "application/dashboards#show"
end
