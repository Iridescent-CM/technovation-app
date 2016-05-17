Rails.application.routes.draw do
  get 'controller/settings'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
  }

  devise_scope :user do
    get '/users/sign_up', to: 'users/registrations#new', as: 'new_user_without_role'
    get '/users/sign_up/:role', to: 'users/registrations#new', as: 'new_user_with_role'
  end

  root 'welcome#index'

  get 'signature/:hash' => 'signature#index'
  post 'signature/:hash' => 'signature#create'
  get 'signature' => 'signature#status'
  post 'signature' => 'signature#resend'

  get 'mentors' => 'mentors#index'

  get 'valid_events' => 'events#valid_events'

  get 'bg_check' => 'bg_check#index'
  post 'bg_check' => 'bg_check#update', as: :bg_check_submit

  resources :users, only: [:show, :edit, :update] do
    member do
      post 'invite', as: 'invite'
      get 'get_certificate'
    end
  end

  resources :teams do
    member do
      post 'join'
      post 'leave'
      post 'submit'

      get 'edit_submission'
      post 'edit_submission'

      get 'event_signup'
      post 'event_signup'
    end
  end

  resources :team_requests, only: [:destroy] do
    member do
      post 'approve'
    end
  end

  resources :rubrics

  resources :events

  resources :scores

  resources :judges
end
