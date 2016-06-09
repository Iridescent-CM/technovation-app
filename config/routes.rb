Rails.application.routes.draw do
  namespace :judges do
    resources :scores
  end

  root to: "judges/scores#index"
end
