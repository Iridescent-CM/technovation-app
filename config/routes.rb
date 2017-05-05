require 'sidekiq/web'
require 'admin_constraint'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

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

  root to: "team_registrations#show"
end
