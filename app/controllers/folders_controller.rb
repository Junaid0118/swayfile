# frozen_string_literal: true

# Folders Class
class FoldersController < ApplicationController
  before_action :set_folder, only: %i[show update]
  before_action :set_user, only: %i[create]

  def show; end

  def create
    folder = Folder.new(name: params[:name], user_id: @current_user.id)
    folder.parent_folder_id = params[:folder_id] if params.key?(:folder_id)
    folder.save!
    render json: folder, status: :created
  end

  def rename
    @folder = Folder.find(params[:id])
    @folder.update_columns(name: params[:name])
    render json: @folder, status: :ok
  end

  def update
    @folder = Folder.find_by!(slug: params[:slug])
    @folder.update_columns(parent_folder_id: params[:parent_folder_id])
    render json: @folder, status: :ok
  end

  def destroy
    @folder = Folder.find(params[:id])
    @folder.destroy
    render json: @folder, status: :ok
  end

  private
  def set_user
    @current_user = User.find_by(id: cookies.signed[:user_id])
  end
end
