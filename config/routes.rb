OmniInventory::Application.routes.draw do
  get "reports/index"
  get "reports/show"
  resources :users 
  resources :sessions, only: [:new, :create, :destroy]
  resources :searchs, only: [:index]
  resources :documents, only: [:show]


   match "/documens/load_tab/:parent/:type/:id"  => "documents#load_tab", as: "load_tab_document", :via => [:get]
  match '/signup', to: 'users#new', via: :get
  match '/signin', to: 'sessions#new', via: :get 
  match '/signout', to: 'sessions#destroy', via: :delete
  match 'auth/:provider/callback', to: 'sessions#create', via: :get
  root to: 'searchs#index'

end
