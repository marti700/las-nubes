Rails.application.routes.draw do
 # resources :users
  get   'welcome/index'
  get   'users/ask_for_access'
  get   'users/ask_for_dropbox_access'
  get   'users/get_authorization_codes'
  get   'users/get_dropbox_access_code'
  get   'users/create'
  post  'users/create', controller: :users, as: 'user_create'
  post  'sessions/create', controller: :sessions, as: 'user_login'
  get   'files/index'
  post  'files/upload', to: 'files#upload', as: 'upload'
  get   'sessions/create', to: 'sessions#create', as: :sessions  
  post  'sessions/create'
  get   'sessions/new'
  
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
