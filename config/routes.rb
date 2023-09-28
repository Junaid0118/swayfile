# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root "application#application"

  get '/dashboard', to: 'application#dashboard'
  get '/get_users', to: 'documents#get_users'
  get '/project-icons', to: 'projects#projects_icon'

	resources :compaigns, only: :show
  resources :projects do
      resources :documents, only: :show
      member do
        get 'users'
        get 'team'
        get 'files'
        get 'activity'
        get 'settings'
      end
    end
end