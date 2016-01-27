class UsersController < ApplicationController

	skip_before_action :require_login, only: [:new, :create, :activate, :ch_pass_request, :edit_pass]

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
			flash_msgs(1, "Something went wrong while trying to activate your account. Please try to activate it later.")
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
	
	def show
		@user = User.find(params[:id])
		if current_user == @user && @user.is_proj_creator?
			@pub_projects = @user.projects.select {|pr| pr.is_public?}
			@prv_projects = @user.projects.select {|pr| pr.is_private?} if @user.is_private?
		end
	end
	
	def edit
		@user = User.find(session[:user_id])
	end
	
	def update
		@user = User.find(session[:user_id])
		# When the user decides he/she wants to change the password
		if ( not user_params[:password].blank? ) && ( not @user.authenticate(user_params[:oldpass]) )
			flash_now_msgs(1, "Wrong username or password entered.")
		elsif @user.update(user_params)
			flash_msgs(0, "Profile updated successfully.")
			redirect_to user_path(@user)
			return
		else
			flash_now_msgs(1, @user.errors.full_messages || "Something went wrong while trying to update your profile.")
		end
		render 'edit'
	end
	
	def destroy
		@user = User.find(session[:user_id])
		if @user.destroy
			UserMailer.bye_mail(@user.email).deliver_now
			flash_msgs(0, "Your account was deleted successfully.")
			session[:user_id] = nil
			redirect_to root_path
		else
			flash_msgs_now(1, "Something went wrong while trying to delete your account.")
			render 'edit'
		end
	end
	
	private
	
	def user_params
		params.require(:user).permit(:username, :email, :password, :password_confirmation, :firstname, :lastname, :acctype, :is_pr_creator)
	end

end
