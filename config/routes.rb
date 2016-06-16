Rails.application.routes.draw do
  namespace :admin do
    resources :score_categories

    root to: 'dashboards#index'
  end

  namespace :judge do
    resources :scores, only: :index

    resources :submissions, only: [] do
      resources :scores
    end
  end

  get 'login', to: 'signins#new', as: :login
  get 'signin', to: 'signins#new', as: :signin

  get 'signup', to: 'signups#new', as: :signup

  match 'logout',  to: 'signins#destroy', as: :logout, via: [:get, :delete]
  match 'signout', to: 'signins#destroy', as: :signout, via: [:get, :delete]

  resources :signins, only: :create
  resource :authentication, only: [:show, :edit, :update]
  post 'authentications', to: "signups#create"

  root to: "static#index"
end
