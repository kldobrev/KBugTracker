class SessionsController < ApplicationController

	def new
	end
	
	def create
		@user = User.find_by(username: params[:session][:username])
		if @user && @user.isActivated? && @user.authenticate(params[:session][:password])
			session[:user_id] = @user.id
			flash_msgs(0, "Welcome, #{@user.username}.")
			flash[:status] = 0
			redirect_to root_path
		else
			flash_now_msgs(1, "Wrong username or password.")
			render 'new'
		end
	end
	
	def destroy
		session[:user_id] = nil
		redirect_to root_path
	end

end
