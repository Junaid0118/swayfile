# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  
  root "application#file_manager"

  get '/dashboard', to: 'application#dashboard'
  get '/get_users', to: 'documents#get_users'
  get '/project-icons', to: 'projects#projects_icon'
  get '/search_projects', to: 'projects#search_projects'

  resources :compaigns, only: :show
  
  resources :projects do
    resources :documents, only: :show
    member do
      get 'users'
      get 'team'
      get 'files'
      get 'activity'
      get 'settings'
      get 'comments'
    end
  end

  resources :folders, only: [:create]
  get 'folders/:slug', to: 'folders#show', as: :folder
  put 'folders/:slug', to: 'folders#update'

  get '/folders', to: 'application#folders'
  get '/file_manager', to: 'application#file_manager'
  get '/settings', to: 'application#settings'
  get '/profile', to: 'application#profile'
  get '/empty_folder', to: 'application#empty_folder'
end
