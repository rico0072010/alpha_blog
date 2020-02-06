Rails.application.routes.draw do
  resources :articles
  get 'about', to: 'pages#about'
  root 'pages#homepage'
  get 'signup', to: 'users#new'
  resources :users, except: [:new]
end
