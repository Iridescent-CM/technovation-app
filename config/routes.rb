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

  namespace :student do
  end

  namespace :mentor do
  end

  namespace :regional_ambassador do
  end

  namespace :judge do
  end

  namespace :admin do
  end

  root to: "team_registrations#new"
end
