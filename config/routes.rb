# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'application#application'
	get '/dashboard', to: 'application#dashboard'

  get '/get_users', to: 'documents#get_users'
  resources :projects do
    resources :documents, only: :show do
      get :users
    end
  end
  resources :compaigns, only: :show
end
