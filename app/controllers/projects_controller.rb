# frozen_string_literal: true

# Projects Controller
class ProjectsController < ApplicationController # rubocop:disable Metrics/ClassLength
  before_action :set_project,
                only: %i[details team signatories contract review show add_member_to_project add_signatory_to_project
                         remove_member_from_team update move_to_folder discussions contract]
  before_action :set_avatars
  before_action :set_user, only: %i[contract team signatories discussions send_invite]
  before_action :authenticate_user!, only: %i[team signatories contract discussions]

  def index
    render layout: 'projects'
  end

  def send_invite
    @project = Project.find(params[:id])
    cookies.signed[:project_id] = @project.id
    if user_signed_in?
      @project.teams.create!(role: 'signatory_party', user_id: current_user.id, user_role: 'Guest')
      redirect_to details_project_path(@project)
    else
      redirect_to new_user_session_path
    end
  end

  def search_projects
    @projects = Project.where('name ILIKE ?', "#{params[:query]}%")
    render json: @projects.pluck(:name, :id)
  end

  def show; end

  def team
    @team_members = @project.contract_party_users.uniq
  end

  def signatories
    @team_members = @project.signatory_party_users.uniq
  end

  def update
    @project.update_columns(name: params[:name])
    render json: @project, status: :ok
  end

  def move_to_folder
    @project.update(folder_id: params[:parent_folder_id])
    render json: @project, status: :ok
  end

  def contract; end

  def settings
    render layout: 'projects'
  end

  def discussions
    @comments = @project.comments.order(id: :desc).where(parent_comment_id: nil).paginate(page: params[:page],
                                                                                          per_page: 1)
  end

  def create
    project = build_project
    project.folder_id = params[:folder_id] if params.key?(:folder_id)
    @project = project.save
    if @project
      Notification.create!(notification_type: 'New Project', user_id: User.first.id,
        text: "Project #{project.name} created", date: DateTime.now)  
        return render json: project, status: :created
    else
      return render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def add_member_to_project
    member_attributes = params['_json'].map do |member|
      {
        user_id: member['user_id'],
        role: 'contract_party',
        user_role: member['user_role']
      }
    end
    @project.teams.create!(member_attributes)
    render json: { 'data' => "/projects/#{@project}/signatories" }, status: 200
  end

  def add_signatory_to_project
    member_attributes = params['_json'].map do |member|
      {
        user_id: member['user_id'],
        role: 'signatory_party',
        user_role: member['user_role']
      }
    end
    @project.teams.create!(member_attributes)
    render json: { 'data' => "/projects/#{@project}/signatories" }, status: 200
  end

  def remove_member_from_team
    @team = @project.teams.find_by(user_id: params[:user_id], role: params[:role])
    @team.destroy
    if params[:role] == 'contract-party'
      redirect_to "/projects/#{@project.id}/team"
    else
      redirect_to "/projects/#{@project.id}/signatories"
    end
  end

  private

  def build_project
    Project.new(name: params[:name], created_by_id: params[:user_id])
  end

  def set_project
    @project = Project.find(params[:id])
    authorize @project
  end

  def set_avatars
    @avatar_urls = Project.with_attached_avatar.map do |project|
      { url: url_for(project.avatar), id: project.id, created_at: project.created_at } if project.avatar.attached?
    end.compact

    @avatar_urls = @avatar_urls.sort_by! { |project_data| project_data[:created_at] }.reverse
  end

  def set_user
    @current_user = User.find_by(id: cookies.signed[:user_id])
  end
end
