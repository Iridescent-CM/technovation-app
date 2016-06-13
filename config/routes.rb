Rails.application.routes.draw do
  namespace :judges do
    resources :scores, only: :index

    resources :submissions, only: [] do
      resources :scores
    end
  end

  get 'login', to: 'signins#new', as: :signin
  resources :signins, only: :create

  root to: "judges/scores#index"
end
