# frozen_string_literal: true

# Clasue Controller
class ClausesController < ApplicationController
  before_action :set_project, only: :create
  before_action :set_clause, only: :update
  before_action :authenticate_user!, only: [:update]
  
  def create
    @clause = @project.clauses.build(content: params[:clause_content], title: params[:clause_name],
                                     user_id: params[:user_id])
    @clause.save!
    render json: @clause
  end

  def update
    @clause.update(content: params[:clause][:content])
    redirect_to "/projects/#{params[:project_id]}/contract"
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_clause
    @clause = Clause.find(params[:id])
  end
end
