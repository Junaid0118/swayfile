# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    def create
      super do |resource|
        if resource.persisted?
          cookies.signed[:user_id] = resource.id
        end
      end
    end
  end
end
