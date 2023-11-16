# frozen_string_literal: true

class SuggestsController < ApplicationController
  before_action :set_clause
  def create
    @suggest = @clause.suggests.build(clause_params)
    @suggest.save!
    redirect_to "/contracts/#{params[:suggest][:project_id]}/contract"
  end

  def update
    @suggest = Suggest.find(params[:id])
    if params[:category] == "rejected"
        @suggest.update(accepted: false)
    else
        if @suggest.suggest_type == "1"
            @clause.update(content: @suggest.comment)
            @suggest.update(accepted: true)
        else
            @clause.update(title: @suggest.comment)
            @suggest.update(accepted: true)
        end
    end
    redirect_to "/contracts/#{params[:project_id]}/contract"
  end

  private

  def set_clause
    @clause = Clause.find(params[:clause_id])
  end

  def clause_params
    params.require(:suggest).permit(:suggest_type, :user_id, :status, :priority, :comment)
  end
end
