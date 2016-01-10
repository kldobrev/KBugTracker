class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	
	helper_method 'isLogged?', 'current_user', 'flash_msgs', 'flash_now_msgs'
	
	def isLogged?
		session[:user_id] != nil
	end

	def current_user
		@current_user ||= User.find(session[:user_id]) if isLogged?
	end
	
	# Helper functions to fill the messages hash
	def flash_msgs(status, messages)
		flash[:status] = status
		flash[:msgs] = [messages].flatten
	end
	
	def flash_now_msgs(status, messages)
		flash.now[:status] = status
		flash.now[:msgs] = [messages].flatten
	end
	
end
