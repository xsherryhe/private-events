Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  resources :users, only: [:show]
  resources :events, only: [:index, :new, :create, :show] do
    resources :registrations, only: [:new, :create], controller: 'event_registrations'
  end
  # Defines the root path route ("/")
  # root "articles#index"
  root "events#index"
end
