class FoldersController < ApplicationController
    before_action :set_folder

    def show
    end

    def create
        folder = Folder.new(name: params[:name])
        folder.parent_folder_id = params[:folder_id] if params.has_key?(:folder_id)
        folder.save!
        render json: folder, status: :created
    end

    def update
        @folder = Folder.find_by!(slug: params[:slug])
        @folder.update(parent_folder_id: params[:parent_folder_id], user_id: User.first.id)
        render json: @folder, status: :ok
    end
end
