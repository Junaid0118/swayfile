# frozen_string_literal: true

# Clasue Controller
class ClausesController < ApplicationController
  before_action :set_project, only: [:create, :approve_clause]
  before_action :set_clause, only: [:update, :approve_clause]
  before_action :authenticate_user!, only: [:update, :approve_clause]

  def create
    @clause = @project.clauses.build(content: params[:clause_content], title: params[:clause_name],
                                     user_id: params[:user_id])
    authorize @clause
    @clause.save!
    render json: @clause
  end

  def approve_clause
    unless @clause.approved_by.include?(@current_user.id)
      @clause.approved_by << @current_user.id 
      @clause.save
    end
    redirect_to "/contracts/#{@project.id}/contract"
  end

  def update
    @clause.update(content: params[:clause][:content])
    redirect_to "/contracts/#{params[:project_id]}/contract"
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_clause
    @clause = Clause.find(params[:id])
    authorize @clause
  end
end
