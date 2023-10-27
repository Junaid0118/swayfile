class ClausesController < ApplicationController
    before_action :set_project
    def create
        @clause = @project.clauses.build(content: params[:clause_content], title: params[:clause_title], user_id: params[:user_id])
        @clause.save!
        render json: @clause
    end

    private

    def set_project
        @project = Project.find(params[:project_id])
    end
end
