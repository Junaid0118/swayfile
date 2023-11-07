class Users::RegistrationsController < Devise::RegistrationsController
    def create
      super do |resource|
        if resource.persisted?
            cookies.signed[:user_id] = resource.id
        end
      end
    end
end
  