Rails.application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'help#api'

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

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :budokop_sensors, only: [:index, :show, :update, :create]
      resources :device_aggregations, only: [:index, :show, :update, :create]
      resources :devices, only: [:index, :show, :update, :create]
      resources :edge_nodes, only: [:index, :show, :update, :create]
      resources :levees, only: [:index, :show, :update]
      resources :measurement_nodes, only: [:index, :show, :update, :create]
      resources :measurements, only: [:index, :show, :update, :create]
      resources :neosentio_sensors, only: [:index, :show, :update, :create]
      resources :parameters, only: [:index, :show, :update, :create]
      resources :pumps, only: [:index, :show, :update, :create]
      resources :fiber_optic_nodes, only: [:index, :show, :update, :create]
      resources :results, only: [:index, :show, :update, :create]
      resources :profiles, only: [:index, :show, :update, :create]
      resources :sections, only: [:index, :show, :update, :create]
      resources :threat_assessment_runs, only: [:index, :show, :update, :create]
      resources :threat_assessments, only: [:index, :show, :update, :create]
      resources :timelines, only: [:index, :show, :update, :create]
      resources :contexts, only: [:index, :show]
      resources :experiments, only: [:index, :show, :update, :create]
      resources :scenarios, only: [:index, :show, :update, :create]
      resources :monitoring, only: [:index]
    end
  end

  get 'help' => 'help#index'
  get 'help/api' => 'help#api'
  get 'help/api/:category'  => 'help#api', as: 'help_api_file'

end
