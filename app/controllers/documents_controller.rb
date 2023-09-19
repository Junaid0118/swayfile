class DocumentsController < ApplicationController    
    def show
        render layout: "projects"
    end

    def get_users
        users = User.all
        render json: users
    end
end
