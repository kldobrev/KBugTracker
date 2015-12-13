class UserMailer < ApplicationMailer

	#default from: 'admin@kbugtracker.com'
	
	def activation_mail(usr)
		@user = usr
		mail(to: @user.email, subject: 'Welcome to KBugTracker!')
	end

end
