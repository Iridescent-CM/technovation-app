require 'sidekiq/web'
require 'admin_constraint'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

  devise_for :users

  devise_scope :user do
    get 'signin', to: 'devise/sessions#new'
    match 'logout', to: 'devise/sessions#destroy', via: [:get, :destroy]
    match 'signout', to: 'devise/sessions#destroy', via: [:get, :destroy]
    get 'signup', to: 'devise/registrations#new'
  end

  root to: "team_registrations#new"

  namespace :legacy do
    namespace :v2 do
      namespace :student do
      end

      namespace :mentor do
      end

      namespace :regional_ambassador do
      end

      namespace :judge do
      end

      namespace :admin do
        resources :background_check_sweeps, only: :create
        resources :background_checks, only: :index
      end
    end
  end
end
