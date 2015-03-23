Rails.application.routes.draw do
  get 'controller/settings'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
  }
  devise_scope :user do
    get '/users/sign_up/:role', to: 'users/registrations#new', as: 'new_user_with_role'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

#  get '/rubrics/:id', to: 'rubrics#show', as: 'rubric'

  get 'signature/:hash' => 'signature#index'
  post 'signature/:hash' => 'signature#create'
  get 'signature' => 'signature#status'
  post 'signature' => 'signature#resend'

  get 'mentors' => 'mentor#index'

  get 'bg_check' => 'bg_check#index'
  post 'bg_check' => 'bg_check#update', as: :bg_check_submit

#  get 'rubric' => 'rubric#index'

  # get 'mentor_coach_check' => 'mentor_coach_check#index'
  # post 'mentor_coach_check' => 'mentor_coach_check#update'


  resources :users, only: [:show, :edit, :update] do
    member do
      post 'invite', as: 'invite'
  
      # get 'mentor_coach'
      # post 'mentor_coach'
    end
  end

  resources :teams do
    member do
      post 'join'
      post 'leave'
      post 'submit'

      get 'edit_submission'
      post 'edit_submission'
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

  #   member do
  #     post 'approve'
  #     delete 'destroy'
  #   end
  # end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
