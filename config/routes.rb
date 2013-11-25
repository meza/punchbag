Punchbag::Application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  root :to => 'sessions#new'

  match '/signup', to: 'users#new', via: 'get'
  match '/follow/:id', to: 'users#follow', via: 'get', :as => :follow_path
  match '/unfollow/:id', to: 'users#unfollow', via: 'get', :as => :unfollow_path
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: ['delete', 'get']
  match '/message/compose', to: 'messages#compose', via: ['get'], :as => :message_compose_path
  match '/messages', to: 'messages#read', via: ['get'], :as => :messages_read_path
  match '/messages', to: 'messages#sendit', via: ['post'], :as => :message_send_path

end
