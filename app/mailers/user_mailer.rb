class UserMailer < ApplicationMailer
	
	def activation_mail(usr)
		@user = usr
		mail(to: @user.email, subject: 'Welcome to KBugTracker!')
	end

end
