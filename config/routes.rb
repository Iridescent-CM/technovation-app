Rails.application.routes.draw do
  namespace :judges do
    resources :scores, only: :index

    resources :submissions, only: [] do
      resources :scores
    end
  end

  root to: "judges/scores#index"
end
