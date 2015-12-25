class SessionsController < ApplicationController

	def new
	end
	
	def create
		@user = User.find_by(username: params[:session][:username])
		if @user and @user.authenticate(params[:session][:password])
			session[:user_id] = @user.id
			flash[:status] = 0
			flash[:msgs] = [ "Welcome, #{@user.username}." ]
			redirect_to root_path
		else
			flash.now[:status] = 1
			flash.now[:msgs] = ["Wrong username or password."]
			render 'new'
		end
	end
	
	def destroy
		session[:user_id] = nil
		redirect_to root_path
	end

end
