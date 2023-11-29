# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome(user_id)
    @user = User.find(user_id)
    mail(
      to: @user.email,
      subject: 'Welcome to SwayFile'
    )
  end

  def verify_email(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Email Verification')
  end

  def invitation(email, url)
    @url = url
    mail(to: email, subject: 'Invitation')
  end
end
