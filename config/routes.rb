Ndc::Application.routes.draw do


  get "oauth/authorize"=>"auth#authorize"       ,as: :authorize
  post "oauth/authorizeit"=>"auth#authorizeit"  ,as: :authorizeit
  post "oauth/access_token"=>"auth#access_token" ,as: :access_token
  get "welcome/index"
  get "login"=>"auth#login"   ,as: :login
  post "auth"=>"auth#auth"    ,as: :auth
  get "logout"=>"auth#logout" ,as: :logout
  get "download/:id" => "grid#download" , :as=>:download
  get "see/:id" => "grid#see" , :as=>:see

  get 'api/user' => "api/user#index" 

  get 'groups/type/:type'=>'groups#type'
  match "users/search"   => "users#search"  , :as => :search_users, :via=>[:get,:post]
  match "groups/search"  => "groups#search",  :as => :search_groups, :via=>[:get,:post]
  match "pages/search"   => "pages#search"  , :as => :search_pages, :via=>[:get,:post]
  get "pages/name/:name"   => "pages#name"  , :as => :page_name
  match "courses/search" => "courses#search", :as => :search_courses, :via=>[:get,:post]
  match "apps/search" => "apps#search", :as => :search_apps, :via=>[:get,:post]
  match "semesters/search" => "semesters#search", :as => :search_semesters, :via=>[:get,:post]
  match "crlogs/search" => "crlogs#search", :as => :search_crlogs, :via=>[:get,:post]
  post "crlog/reply" => "crlogs#reply", :as => :crlog_reply
  match "teachers/search" => "teachers#search", :as => :search_teachers, :via=>[:get,:post]
  match "students/search" => "students#search", :as => :search_students, :via=>[:get,:post]
  match "students/upload" => "students#upload", :as => :upload_students, :via=>[:get,:post]

  resources :students
  resources :teachers
  resources :tokens
  resources :apps
  resources :pages
  resources :sites
  resources :users
  resources :courses
  resources :semesters
  resources :groups
  resources :cr_schedules
  resources :crlogs
  resources :seats

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
