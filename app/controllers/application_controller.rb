class ApplicationController < ActionController::Base # rubocop:disable Style/Documentation
  protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_avatars, only: %i[empty_folder folders file_manager]
  before_action :set_folder, only: :folders
  before_action :set_folders, only: :folders
  before_action :authenticate_user!, only: :file_manager

  def after_sign_in_path_for(_resource)
	  root_path
  end

  def application
    render layout: "application"
  end

  def dashboard
    render layout: "dashboard"
  end

  def profile
    render json: { message: "Profile page" }
  end

  def folders
    @folders = @folder.subfolders
    @projects = @folder.projects
    render layout: "file_manager"
  end

  def file_manager
    @folders = Folder.where(parent_folder_id: nil)
    @projects = Project.where(folder_id: nil)
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
    @folder = Folder.find_by!(slug: params[:slug])
  end

  def set_folders
    @all_folders = Folder.select(:name, :id)
  end

end
