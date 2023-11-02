# frozen_string_literal: true

class UsersController < ApplicationController
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

      # Loop through the params and update only the fields that are present
      params.each do |key, value|
        @record[key] = value if @record.respond_to?(key)
      end
    end

    if @record.save
      render json: @record, status: :ok
    else
      render json: { errors: @record.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
