class ErrorsController < ApplicationController
    def unauthorized
        render 'errors/unauthorized', status: :unauthorized
      end
end
