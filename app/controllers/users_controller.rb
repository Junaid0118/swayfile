# frozen_string_literal: true

class UsersController < ApplicationController
  def update_pending_action
    user = User.find(params[:user_id])
    user.update(pending_actions: params[:pending_action])
    head :ok
  end

  def remove_avatar
    current_user = User.find(params[:user_id])
    current_user.avatar.purge # Removes the attached avatar from Active Storage
    render json: { message: 'Avatar removed successfully' }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def attach_avatar
    # Logic to handle attaching the avatar to the user
    # You might use params[:avatar] to access the uploaded file
    # Then save it to the user or handle it based on your application's needs
    user = User.find(params[:user_id])
    user.avatar.attach(params[:avatar])
    
    render json: { message: 'Avatar attached successfully' }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def update_project_update
    user = User.find(params[:user_id])
    user.update(project_update: params[:project_update])
    head :ok
  end

  def update_subscription_update
    user = User.find(params[:user_id])
    user.update(subscription_update: params[:subscription_update])
    head :ok
  end

  def update
    @record = User.find(params[:id])
    if params.key?(:password)
      @record.password = params[:password]
      @record.password_confirmation = params[:password_confirmation]
    else
      if params[:name].present?
        full_name = params[:name].split(' ')
        @record.first_name = full_name[0]
        @record.last_name = full_name[1..].join(' ')

        # Remove the "name" parameter from params
        params.delete(:name)
      end

      params.delete(:controller)
      params.delete(:action)
      # Loop through the params and update only the fields that are present
      params.each do |key, value|
        @record[key] = value
      end
    end
    if @record.save
      render json: @record, status: :ok
    else
      render json: { errors: @record.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
