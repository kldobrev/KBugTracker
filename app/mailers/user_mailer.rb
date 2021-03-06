class UserMailer < ApplicationMailer

  def activation_mail(usr)
    @user = usr
    mail(to: @user.email, subject: 'Welcome to KBugTracker!')
  end

  def ch_pass_mail(usr)
    @user = usr
    mail(to: @user.email, subject: 'KBugTracker: Request to change password.')
  end

  def bye_mail(email)
    mail(to: email, subject: "KBugTracker: Goodbye!")
    end

end

