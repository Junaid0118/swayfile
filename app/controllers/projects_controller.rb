# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: :create
  before_action :set_project, only: :show
  before_action :set_avatars

  def index 
    render layout: 'projects'
  end

  def search_projects
    @projects = Project.where("name LIKE ?", "#{params[:query]}%")
    render json: @projects.pluck(:name, :id)
  end

  def show
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
      create_teams(project)

      return render json: project, status: :created
    else
      return render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def build_project
    Project.new(project_params)
  end

  def create_teams(project)
    members = params[:members].split(',')
    signatory_ids = params[:sign_ids].split(',')

    team_attributes = build_team_attributes(members, signatory_ids)
    project.teams.create!(team_attributes)
  end

  def build_team_attributes(members, signatory_ids)
    member_attributes = members.map { |user_id| { user_id: user_id, role: 'contract_party' } }
    signatory_attributes = signatory_ids.map { |user_id| { user_id: user_id, role: 'signatory_party' } }

    member_attributes.concat(signatory_attributes)
  end

  def project_params
    base_params = {
      name: params[:name],
      project_type: params[:project_type],
      description: params[:description],
      status: params[:status],
      date: params[:date],
    }
  
    base_params[:avatar] = params[:file] unless params[:file] == "undefined"
  
    base_params
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
