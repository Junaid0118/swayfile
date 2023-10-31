# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: [:details, :team, :signatories, :contract, :review, :show, :add_member_to_project, :add_signatory_to_project, :remove_member_from_team, :update, :move_to_folder, :discussions, :contract]
  before_action :set_avatars
  before_action :set_user, only: [:contract, :team, :signatories, :discussions]
  before_action :authenticate_user!, only: [:team, :signatories, :contract, :discussions]

  def index 
    render layout: 'projects'
  end

  def search_projects
    @projects = Project.where("name ILIKE ?", "#{params[:query]}%")
    render json: @projects.pluck(:name, :id)
  end  

  def show
  end

  def team
    @team_members = @project.contract_party_users
  end

  def signatories
    @team_members = @project.signatory_party_users
  end

  def update
    @project.update_columns(name: params[:name])
    return render json: @project, status: :ok
  end

  def move_to_folder
    @project = @project.update(folder_id: params[:parent_folder_id])
    return render json: @project, status: :ok
  end

  def contract
  end


  def settings
    render layout: 'projects'
  end

  def discussions
    @comments = @project.comments.order(id: :desc).where(parent_comment_id: nil).paginate(page: params[:page], per_page: 1)
  end

  def create
    project = build_project
    project.folder_id = params[:folder_id] if params.has_key?(:folder_id)
    if project.save
      Notification.create!(notification_type: "New Project", user_id: User.first.id, text: "Project #{project.name} created", date:DateTime.now)
      return render json: project, status: :created
    else
      return render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def add_member_to_project
    member_attributes = params[:compose_to].split(",").map { |user_id| { user_id: user_id, role: 'contract_party' } }
    @project.teams.create!(member_attributes)
    redirect_to "/projects/#{@project.id}/team"
  end

  def add_signatory_to_project
    member_attributes = params["_json"].map do |member|
      {
        user_id: member["user_id"],
        role: 'signatory_party',
        user_role: member["user_role"]
      }
    end
    @project.teams.create!(member_attributes) 
    render json: { "data" => "/projects/#{@project}/signatories" }, status: 200
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
    @current_user = User.find(cookies.signed[:user_id])
  end
end
