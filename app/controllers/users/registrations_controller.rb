# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    def create
      super do |resource|
        if resource.persisted?
          cookies.signed[:user_id] = resource.id
          User.find(resource.id).update(last_login: Time.current)
          #UserMailer.welcome(resource.id).deliver_now
        end
      end
    end
  end
end
