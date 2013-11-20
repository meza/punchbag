Punchbag::Application.routes.draw do
  resources :users

  match '/signup', to: 'users#new', via: 'get'
end
