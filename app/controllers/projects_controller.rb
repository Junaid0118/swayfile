# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: :create
  before_action :set_project, only: :show
  before_action :set_avatars

  def index 
    render layout: 'projects'
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

  def new; end

  def create
    project = build_project
    byebug
    if project.save
      create_teams(project)

      render json: project, status: :created
    else
      render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
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
    {
      name: params[:name],
      project_type: params[:project_type],
      description: params[:description],
      status: params[:status],
      date: params[:date],
      avatar: params[:file]
    }
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def set_avatars
    @avatar_urls =  Project.with_attached_avatar.map do |project|
      { url: url_for(project.avatar), id: project.id } if project.avatar.attached?
    end.compact   
  end
end
