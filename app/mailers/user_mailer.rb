class UserMailer < ApplicationMailer
    def welcome(user_id)
        @user = User.find(user_id)
         mail(to: @user.email, subject: 'Welcome to Starter App')
    end

    def verify_email(user_id)
        @user = User.find(user_id)
        mail(to: @user.email, subject: 'Email Verification')
    end

    def invitation(user_id)
        @user = User.find(user_id)
        mail(to: @user.email, subject: 'Invitation')
    end
end
