class SessionsController < ApplicationController

	skip_before_action :require_login, only: [:new, :create]

	def new
	end
	
	def create
		@user = User.find_by(username: params[:session][:username])
		if @user && @user.is_activated? && @user.authenticate(params[:session][:password])
			session[:user_id] = @user.id
			flash_msgs(0, "Welcome, #{@user.username}.")
			redirect_to user_path(session[:user_id])
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
