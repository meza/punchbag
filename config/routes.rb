Punchbag::Application.routes.draw do
  resources :users, :except => [:show, :edit, :destroy]
  resources :sessions, only: [:new, :create, :destroy]

  root :to => 'sessions#new'

  match '/signup', to: 'users#new', via: 'get'
  match '/users/:username', to: 'users#show', via: 'get'
  match '/users/:username', to: 'users#destroy', via: 'delete'
  match '/users/:username/edit', to: 'users#edit', via: 'get'
  match '/follow/:username', to: 'users#follow', via: 'get', :as => :follow_path
  match '/unfollow/:username', to: 'users#unfollow', via: 'get', :as => :unfollow_path
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: ['delete','get']
end
