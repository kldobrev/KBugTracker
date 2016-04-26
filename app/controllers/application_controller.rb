class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	
	before_action :require_login
	helper_method 'is_logged?', 'current_user', 'flash_msgs', 'flash_now_msgs', :get_req_type_literal
	
	def is_logged?
		session[:user_id] != nil
	end

	def current_user
		@current_user ||= User.find(session[:user_id]) if is_logged?
	end
	
        def get_req_type_literal(type)
          case type
            when 0 then "Join project"
            when 1 then "Project invitation"
            when 2 then "Receive ownership"
            else ""
          end
        end

	private
	
	# Helper functions to fill the messages hash
	def flash_msgs(status, messages)
		flash[:status] = status
		flash[:msgs] = [messages].flatten
	end
	
	def flash_now_msgs(status, messages)
		flash.now[:status] = status
		flash.now[:msgs] = [messages].flatten
	end
	
	def require_login
		unless is_logged?
			flash_msgs(1, "You must be logged in to view this page.")
			redirect_to root_path
		end
	end
	
end
