Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  resources :users, only: [:show]
  resources :events do
    resources :registrations, except: [:index, :show], controller: 'event_registrations'
    resources :invitations, except: [:index, :edit]
  end
  resources :my_events, only: [:index]
  resources :invitations, only: [:index]
  # Defines the root path route ("/")
  # root "articles#index"
  root 'events#index'
end
