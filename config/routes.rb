Rails.application.routes.draw do
  namespace :judges do
    resources :scores, only: :index

    resources :submissions, only: [] do
      resources :scores
    end
  end

  get 'login', to: 'signins#new', as: :login
  get 'signin', to: 'signins#new', as: :signin

  match 'logout',  to: 'signins#destroy', as: :logout, via: [:get, :delete]
  match 'signout', to: 'signins#destroy', as: :signout, via: [:get, :delete]

  resources :signins, only: :create

  root to: "static#index"
end
