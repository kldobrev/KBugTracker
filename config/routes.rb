Rails.application.routes.draw do
  get 'groups/index'

  get 'groups/create'

  get 'groups/add_member'

  get 'groups/remove_member'

  get 'groups/destroy'

  get 'statics/index'

  get 'statics/guide'

  get 'statics/reccomendations'

  get 'statics/application'

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
	
	resources :users
	resources :projects
	
	# statics
	root 'statics#index'
	get 'search' => 'statics#search'
	
	# users
	get 'signup' => 'users#new', as: 'signup'
	get 'users/activate/:atk' => 'users#activate', as: 'activate'
	post 'ch_pass_request' => 'users#ch_pass_request'
	get 'users/edit_pass/:cpt' => 'users#edit_pass', as: 'edit_pass'
	patch 'users/update_pass/:cpt' => 'users#update_pass'
	
	#sessions
	get 'login' => 'sessions#new'
	post 'login' => 'sessions#create'
	delete 'logout' => 'sessions#destroy'
	
	#projects
	get 'tag/:tagid' => 'projects#show_tag', as: 'show_tag'
        post 'projects/:pr/add_to_proj/:usr' => 'projects#add_to_proj', as: 'add_to_proj'
        post 'projects/:pr/add_to_group/:usr' => 'projects#add_to_group', as: 'add_to_group'
        post 'projects/:pr/remove_from_proj/:usr' => 'projects#remove_from_proj', as: 'remove_from_proj'
        post 'projects/:pr/remove_from_group/:usr' => 'projects#remove_from_group', as: 'remove_from_group'
        get 'editable_projects/:usr' => 'projects#all_editable'
        get 'owned_projects/:usr' => 'projects#all_owned'
        get 'projects/assigned/:usr' => 'projects#assigned', as: 'assigned_projects'
        delete 'projects/:pr/members/remove/:mem' => 'projects#remove_proj_member', as: 'remove_pr_member'
	
        #requests
        post 'projects/:pr/join' => 'requests#join_proj', as: 'join_project'
        post 'projects/:pr/invite/:usr' => 'requests#invite_to_proj', as: 'invite_to_proj'
        post 'projects/:pr/ask_take_own/:usr' => 'requests#ask_take_ownership', as: 'ask_take_ownership'
        get 'users/:usr/requests' => 'requests#index', as: 'all_requests'
        get 'projects/:pr/requests' => 'requests#proj_requests', as: 'proj_requests'
        post 'requests/accept_request/:req' => 'requests#accept_request', as: 'accept_request'
        delete 'requests/:req/destroy' => 'requests#destroy', as: 'destroy_request'

        #groups
        get '/projects/:pr/groups/:gr' => 'projects#show_group', as: 'group'
        get '/all_proj_members/:gr' => 'projects#all_proj_members', as: 'all_proj_members'
        post '/projects/:pr/groups/:gr/add_member/:mem' => 'projects#add_group_member', as: 'add_group_member'
        delete '/projects/:pr/groups/:gr/remove_member/:mem' => 'projects#remove_group_member', as: 'remove_group_member'
        
end
