class UsersController < ApplicationController

	def new
		@user = User.new
	end
	
	def create
		@user = User.new(user_params)
		@user.act_code = SecureRandom.base64
		if @user.save
			UserMailer.activation_mail(@user).deliver_now
			flash_msgs(0, "New account successfully created. Please check your email to activate it.")
			redirect_to root_path
		else
			flash_now_msgs(1, @user.errors.full_messages)
			render 'new'
		end
	end
	
	def activate
		@user = User.find_by(act_code: params[:atk])
		if @user and @user.update(act_code: nil)
			flash_msgs(0, "Your account is now active. Please login to use the application.")
		else
			flash_msgs_now(1, "Something went wrong while trying to activate your account. Please try to activate it later.")
		end
		redirect_to root_path
	end
	
	def ch_pass_request
		@user = User.find_by(email: params[:usr_email])
		if @user && @user.update(ch_pass_code: SecureRandom.base64)
			UserMailer.ch_pass_mail(@user).deliver_now
			flash_msgs(0, "You have requested to change your password. Please check your email to proceed.")
		else
			flash_msgs(1, "Invalid email address entered.")
		end
			redirect_to login_path
	end
	
	def edit_pass
		@user = User.find_by(ch_pass_code: params[:cpt])
		unless @user
			flash_msgs(1, "Your request cannot be processed.")
			redirect_to root_path
		end
	end
	
	def update_pass
		@user = User.find_by(ch_pass_code: params[:cpt])
		if @user && @user.email == user_params[:email]
			@user.password_digest = nil		#Triggering the blank password check
			@user.ch_pass_code = nil
			if @user.update(user_params)
				flash_msgs(0, "Password updated successfully.")
				redirect_to root_path
			else
				flash_now_msgs(1, @user.errors.full_messages)
				render 'edit_pass'
			end
		else
			flash_now_msgs(1, "The email you have entered is not correct.")
			render 'edit_pass'
		end
	end
	
	private
	
	def user_params
		params.require(:user).permit(:username, :email, :password, :password_confirmation, :firstname, :lastname, :acctype)
	end

end
