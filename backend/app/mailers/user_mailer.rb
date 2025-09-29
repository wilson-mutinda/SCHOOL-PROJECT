class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to my App!')
  end

  def forgot_password_email(user, token)
    @user = user
    @reset_url = "http://127.0.0.1:3000/api/v1/reset_password?token=#{token}"
    mail(to: @user.email, subject: "Reset your password")
  end

end
