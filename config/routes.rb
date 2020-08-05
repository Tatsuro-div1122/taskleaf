Rails.application.routes.draw do
  namespace :admin do
    resources :users
  end

  resources :tasks
  root to: 'tasks#index'
end
