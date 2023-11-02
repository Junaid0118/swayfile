class Users::SessionsController < Devise::SessionsController
    def create
      super do |resource|
        if resource.persisted?
          # Set the user ID in a cookie
          User.find(resource.id).update(last_login: Time.current)
          cookies.signed[:user_id] = resource.id
        end
      end
    end
  end
  