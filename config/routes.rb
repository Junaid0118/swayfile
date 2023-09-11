Rails.application.routes.draw do
  devise_for :users
	root "application#application"

	get '/dashboard', to: 'application#dashboard'

	resources :projects, only: :index
end
