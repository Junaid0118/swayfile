class ApplicationController < ActionController::Base # rubocop:disable Style/Documentation
  protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_resource)
	  root_path
  end

  def application
    render layout: "application"
  end

  def dashboard
    render layout: "dashboard"
  end

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path, :notice => 'if you want to add a notice'
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password)}
  end
end
