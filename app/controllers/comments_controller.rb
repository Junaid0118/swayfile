class CommentsController < ApplicationController
    before_action :authenticate_user
    before_action :set_project
    def create
        @comment = @project.comments.build(user_id: @current_user.id, content: params[:comment][:message], parent_comment_id: params[:comment][:parent_comment_id])
        @comment.save!
        redirect_to " /contracts/#{@project.id}/discussions"
    end

    private

    def authenticate_user
        @current_user = User.find(cookies.signed[:user_id])
    end

    def set_project
        @project = Project.find(params[:id])
    end
end
