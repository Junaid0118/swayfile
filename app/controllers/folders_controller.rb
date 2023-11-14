# frozen_string_literal: true

# Folders Class
class FoldersController < ApplicationController
  before_action :set_folder, only: %i[show update]

  def show; end

  def create
    folder = Folder.new(name: params[:name], user_id: params[:user_id])
    folder.parent_folder_id = params[:folder_id] if params.key?(:folder_id)
    folder.save!
    render json: folder, status: :created
  end

  def send_invite
    @folder = Folder.find(params[:id])
    cookies.signed[:folder_id] = @folder.id
    if user_signed_in?
      @folder.invitees << current_user
      @folder.projects.each do |project|
        project.teams.create!(role: 'signatory_party', user_id: current_user.id, user_role: 'Guest')
      end
      redirect_to "/folders?slug=#{@folder.slug}"
    else
      redirect_to new_user_session_path
    end
  end

  def bulk_delete
    request_body = JSON.parse(request.body.read)
    request_body.each do |item|
      if item['item_type'] == 'folder'
        Folder.find(item['item_id']).destroy
      else
        Project.find(item['item_id']).destroy
      end
    end
    render json: {}, status: :ok
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
end
