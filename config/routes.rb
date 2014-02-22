OmniInventory::Application.routes.draw do
  resources :users 
  resources :sessions, only: [:new, :create, :destroy]
  resources :searchs, only: [:index]


  match '/signup', to: 'users#new', via: :get
  match '/signin', to: 'sessions#new', via: :get 
  match '/signout', to: 'sessions#destroy', via: :delete
  match 'auth/:provider/callback', to: 'sessions#create', via: :get
  root to: 'searchs#index'

end
