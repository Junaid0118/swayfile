# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
    def welcome
        user = User.first
        UserMailer.welcome(user.id)
      end

      def verify_email
        user = User.first
        UserMailer.verify_email(user.id)
      end
  
      def invitation
        user = User.first
        UserMailer.invitation(user.id)
      end

end
