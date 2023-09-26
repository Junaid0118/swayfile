# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    render layout: 'projects'
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
    byebug
    project = build_project

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
      date: params[:date]
    }
  end
end
