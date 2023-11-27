# frozen_string_literal: true

class SuggestsController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  before_action :set_clause
  def create
    @suggest = @clause.suggests.build(clause_params)
    @suggest.save!
    redirect_to "/contracts/#{params[:suggest][:project_id]}/contract"
  end

  def update
    @suggest = Suggest.find(params[:id])
    if params[:category] == 'rejected'
      @suggest.update(accepted: false)
    else
      if @suggest.suggest_type == '1'
        @clause.clause_histories.create(action: 'CLAUSE DETAILS CHANGE', before_value: @clause.content,
                                        after_value: @suggest.comment, user_id: @current_user.id)
        @clause.update(content: @suggest.comment)
      else
        @clause.clause_histories.create(action: 'CLAUSE NAME CHANGE', before_value: @clause.title,
                                        after_value: @suggest.comment, user_id: @current_user.id)
        @clause.update(title: @suggest.comment)
      end
      @suggest.update(accepted: true)
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
