OmniInventory::Application.routes.draw do
  resources :importers

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :searchs, only: [:index]
  resources :documents, only: [:show]
  resources :reports

  match "/importers/:id/run"  => "importers#run", as: "run_importer", :via => [:get]
  match "/documents/load_tab/:parent/:type/:id"  => "documents#load_tab", as: "load_tab_document", :via => [:get]
  match "/reports/load_fields/:collection"  => "reports#load_fields", as: "load_fields_report", :via => [:get]
  match '/signup', to: 'users#new', via: :get
  match '/signin', to: 'sessions#new', via: :get
  match '/signout', to: 'sessions#destroy', via: :delete
  match 'auth/:provider/callback', to: 'sessions#create', via: :get
  root to: 'searchs#index'

end
