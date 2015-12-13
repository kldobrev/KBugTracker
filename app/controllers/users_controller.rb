class UsersController < ApplicationController

	def new
		@user = User.new
	end
	
	def create
		@user = User.new(user_params)
		@user.act_code = SecureRandom.base64
		if @user.save
			UserMailer.activation_mail(@user).deliver_now
			flash[:status] = 0
			flash[:msgs] = ["New account successfully created. Please check your email to activate it."]
			redirect_to root_path
		else
			flash.now[:status] = 1
			flash.now[:msgs] = @user.errors.full_messages
			render 'new'
		end
	end
	
	def activate
		@user = User.find_by(act_code: params[:atk])
		if @user and @user.update(act_code: nil)
			flash[:status] = 0
			flash[:msgs] = ["Your account is now active. Please login to use the application."]
		else
			flash[:status] = 1
			flash[:msgs] = ["Something went wrong while trying to activate your account. Please try to activate it later."]
		end
		redirect_to root_path
	end
	
	private
	
	def user_params
		params.require(:user).permit(:username, :email, :password, :password_confirmation, :firstname, :lastname, :acctype)
	end

end
