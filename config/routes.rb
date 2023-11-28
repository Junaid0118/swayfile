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
  post '/update_user_pending_action', to: 'users#update_pending_action'
  post '/update_user_project_update', to: 'users#update_project_update'
  post '/update_subscription_update', to: 'users#update_subscription_update'
  post '/users/attach_avatar', to: 'users#attach_avatar'
  post '/users/remove_avatar', to: 'users#remove_avatar'


  get '/unauthorized', to: 'errors#unauthorized', as: :unauthorized

  resources :compaigns, only: :show
  resources :notifcations, only: :index
  resources :users, only: :update

  resources :projects, path: 'contracts' do
    resources :documents, only: :show
    member do
      resources :comments, only: :create, shallow: true
      resources :clauses,  only: [:create, :update], shallow: true do
        resources :suggests
        member do
          get :approve_clause
        end
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
      post 'update_party'
      post 'update_role'
      get 'remove_pending_user'
      get 'close_contract'
    end
  end

  resources :folders, only: [:create, :destroy]
  get 'folders/:slug', to: 'folders#show'
  get 'folders/:id/rename', to: 'folders#rename', as: :rename_folder
  get 'folders/:id/send_invite', to: 'folders#send_invite'
  put 'folders/:slug', to: 'folders#update'

  post '/bulk_delete', to: 'folders#bulk_delete'

  get '/folders', to: 'application#folders'
  get '/file_manager', to: 'application#file_manager'
  get '/settings', to: 'application#settings'
  get '/profile', to: 'application#profile'
  get '/empty_folder', to: 'application#empty_folder'
end
