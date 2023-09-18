Rails.application.routes.draw do
  devise_for :users
  root "application#application"

  get '/dashboard', to: 'application#dashboard'

	resources :compaigns, only: :show
  resources :projects do
      member do
        get 'users'
        get 'team'
        get 'files'
        get 'activity'
        get 'settings'
      end
    end
end
