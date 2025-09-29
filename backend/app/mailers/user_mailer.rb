class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to my App!')
  end

  def forgot_password_email(user, token)
    @user = user
    @reset_url = "http://127.0.0.1:5173/reset-password?token=#{token}"
    mail(to: @user.email, subject: "Reset your password")
  end

end
