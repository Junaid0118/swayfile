Rails.application.routes.draw do
	root "application#application"

	get '/dashboard', to: 'application#dashboard'
end
