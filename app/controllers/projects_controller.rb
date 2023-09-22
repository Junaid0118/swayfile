class ProjectsController < ApplicationController
    before_action :project_params, only: :create
    def index
        render layout: "projects"
    end

    def users
        render layout: "projects"
    end

    def files
        render layout: "projects"
    end

    def settings
        render layout: "projects"
    end

    def activity
        render layout: "projects"
    end

    def create
        byebug
        project = Project.new(project_params)
        if project.save
            render json: project, status: :created
        else
            render json: {}, status: :unprocessable_entity
        end
    end

    private

    def project_params
        {
            name: params[:name],
            project_type: params[:type],
            description: params[:description],
            status: params[:status],
            date: params[:date]
        }
    end
end
