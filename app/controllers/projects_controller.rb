# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: :create
  before_action :set_project, only: [:details, :team, :signatories, :contract, :review, :show, :remove_member_from_team, :add_member_to_project, :add_signatory_to_project, :remove_member_from_team]
  before_action :set_avatars

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

  def users
    render layout: 'projects'
  end

  def files
    render layout: 'projects'
  end

  def settings
    render layout: 'projects'
  end

  def activity
    render layout: 'projects'
  end

  def comments
    render layout: 'projects'
  end

  def create
    project = build_project
    project.folder_id = params[:folder_id] if params.has_key?(:folder_id)
    if project.save
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
    member_attributes = params[:compose_to].split(",").map { |user_id| { user_id: user_id, role: 'signatory_party' } }
    @project.teams.create!(member_attributes)
    redirect_to "/projects/#{@project.id}/signatories"
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
    Project.new(project_params)
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def set_avatars
    @avatar_urls = Project.with_attached_avatar.map do |project|
      { url: url_for(project.avatar), id: project.id, created_at: project.created_at } if project.avatar.attached?
    end.compact
  
    @avatar_urls = @avatar_urls.sort_by! { |project_data| project_data[:created_at] }.reverse
  end
  
end
