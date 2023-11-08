# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root "application#file_manager"

  get '/dashboard', to: 'application#dashboard'
  get '/get_users', to: 'documents#get_users'
  get '/project-icons', to: 'projects#projects_icon'
  get '/search_projects', to: 'projects#search_projects'

  get '/unauthorized', to: 'errors#unauthorized', as: :unauthorized

  resources :compaigns, only: :show
  resources :notifcations, only: :index
  resources :users, only: :update

  resources :projects do
    resources :documents, only: :show
    member do
      resources :comments, only: :create, shallow: true
      resources :clauses,  only: [:create, :update], shallow: true do
        resources :suggests
      end

      get 'team'
      get 'settings'
      get 'discussions'

      get 'details'
      get 'team'
      get 'signatories'
      get 'contract'
      get 'review'
      get 'send_invite'

      post 'add_member_to_project'
      post 'add_signatory_to_project'
      get 'remove_member_from_team'
      put 'move_to_folder' 
    end
  end

  resources :folders, only: [:create, :destroy]
  get 'folders/:slug', to: 'folders#show'
  get 'folders/:id/rename', to: 'folders#rename', as: :rename_folder
  put 'folders/:slug', to: 'folders#update'

  get '/folders', to: 'application#folders'
  get '/file_manager', to: 'application#file_manager'
  get '/settings', to: 'application#settings'
  get '/profile', to: 'application#profile'
  get '/empty_folder', to: 'application#empty_folder'
end
