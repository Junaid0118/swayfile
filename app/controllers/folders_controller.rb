class FoldersController < ApplicationController

    def show
    end

    def create
        folder = Folder.new(name: params[:name])
        folder.parent_folder_id = params[:folder_id] if params.has_key?(:folder_id)
        folder.save!
        render json: folder, status: :created
    end
end
