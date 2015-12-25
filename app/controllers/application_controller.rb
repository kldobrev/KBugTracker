class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	
	helper_method 'isLogged?', 'current_user' 
	
	def isLogged?
		session[:user_id] != nil
	end

	def current_user
		@current_user ||= User.find(session[:user_id]) if isLogged?
	end
	
end
