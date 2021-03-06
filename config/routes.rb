Rails.application.routes.draw do
  # static_pages
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  # users
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  patch '/users/:id/edit', to: 'users#update'
  put '/users/:id/edit', to: 'users#update'
  resources :users, only: [:index, :show, :edit, :destroy]

  # sessions
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # account_activations
  resources :account_activations, only: [:edit]

  # password_resets
  resources :password_resets, only: [:new, :create, :edit, :update]

  # microposts
  resources :microposts, only: [:create, :destroy]
end
