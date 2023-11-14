class ApplicationController < ActionController::Base # rubocop:disable Style/Documentation
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_avatars, only: %i[empty_folder folders file_manager settings]
  before_action :set_folder, only: :folders
  before_action :set_folders, only: :folders
  before_action :authenticate_user!, only: [:file_manager, :folders, :profile, :settings]
  before_action :set_notifications, unless: :devise_controller?
  before_action :set_user, only: [:file_manager, :folders]

  def after_sign_in_path_for(resource)
    # Set the user-specific value in a cookie here
    cookies[:user_value] = resource.user_value

    # Redirect to the desired path
    new_project_path
  end

  def application
    render layout: "application"
  end

  def dashboard
    render layout: "dashboard"
  end

  def profile
  end

  def folders
    cookies.delete(:project_id)
    cookies.delete(:folder_id)
    @folders = @folder.subfolders
    @projects = @folder.projects
    render layout: "file_manager"
  end

  def file_manager
    project = Project.find_by(id: cookies.signed[:project_id])
    folder = Folder.find_by(id: cookies.signed[:folder_id])
    return redirect_to send_invite_project_path(project) if project
    return redirect_to "/folders?slug=#{folder.slug}" if folder
    
    @folders = (@current_user.folders.where(parent_folder_id: nil) + @current_user.invitees_folders).uniq
    @projects = Project.joins('LEFT JOIN teams AS contract_teams ON projects.id = contract_teams.project_id').joins('LEFT JOIN teams AS signatory_teams ON projects.id = signatory_teams.project_id').where('projects.created_by_id = :user_id OR contract_teams.user_id = :user_id OR signatory_teams.user_id = :user_id', user_id: @current_user.id).order(id: :desc).where(folder_id: nil).uniq
    render layout: "file_manager"
  end

  def settings
    render layout: "file_manager"
  end

  def empty_folder
    render layout: "file_manager"
  end

  def after_sign_in_path_for(resource)
    file_manager_path
  end

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      return redirect_to new_user_session_path, :notice => 'if you want to add a notice'
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password)}
  end

  def set_avatars
    @avatar_urls =  Project.with_attached_avatar.map do |project|
      { url: url_for(project.avatar), id: project.id } if project.avatar.attached?
    end.compact   

    @avatar_urls = @avatar_urls.sort_by! { |project_data| project_data[:created_at] }.reverse
  end

  def set_folder
    @folder = Folder.find_by(slug: params[:slug])
  end

  def set_folders
    @all_folders = Folder.select(:name, :id)  
  end

  def set_notifications
    @notifications = Notification.all.order(id: :desc)
  end

  def set_user
    @current_user = User.find(cookies.signed[:user_id])
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to view this page."
    redirect_to unauthorized_path
  end
end
