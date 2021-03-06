require 'sidekiq/web'

Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :tasks
  root 'home#index'
  resources :reports do
    get 'view', to: 'reports#view', as: :view, on: :member
  end

  resources :projects do
    resources :reports
    member do
      get 'show_email'
    end
  end

  resources :recaps do
    collection do
      get ':start_date/:end_date', to: 'recaps#index', as: :range
      get ':project_id/:user_id/:start_date/:end_date/view', to: 'recaps#view', as: :view
    end
  end

  resources :projects do
    resources :users do
      resources :recaps
    end
  end
  get 'test', to: 'recaps#test'
  get 'profile', to: 'users#show', as: :profile_user

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  Sidekiq::Web.use Rack::Auth::Basic do |user, password|
    [user, password] == [ ENV["SIDEKIQ_USERNAME"], ENV["SIDEKIQ_PASSWORD"] ]
  end unless Rails.env.development?

  mount Sidekiq::Web, at: '/sidekiq'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
