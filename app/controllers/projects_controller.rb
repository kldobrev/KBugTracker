class ProjectsController < ApplicationController
	
	skip_before_action :require_login, only: [:show]
	skip_before_action :require_proj_access, only: [:new, :create]
	
	def new
		@project = Project.new
	end
	
	def create
		@project = current_user.projects.build(project_params)
		if @project.save
			flash_msgs(0, "Project created successfully.")
			redirect_to user_path(current_user)
		else
			flash_now_msgs(1, @project.errors.full_messages)
			render 'new'
		end
	end
	
	def show
		@project = Project.find(params[:id])
	end
	
	def edit
		@project = Project.find(params[:id])
	end
	
	def update
		@project = Project.find(params[:id])
		if @project.update(project_params)
			flash_msgs(0, "Project updated successfully.")
			redirect_to project_path(@project)
		else
			flash_now_msgs(1, @project.errors.full_messages)
			render 'edit'
		end
	end
	
	def destroy
		@project = Project.find(params[:id])
		if @project.is_editor?(current_user) && @project.destroy
			flash_msgs(0, "The project has been deleted.")
		else
			flash_msgs(1, "The project could not be deleted. Please try again.")
		end
		redirect_to user_path(@project.user)
	end
	
	
	private
	
	def project_params
		params.require(:project).permit(:title, :description, :prtype)
	end
	
	# Denies access for public users to private projects
	def require_proj_access
		@project = Project.find(params[:id])
		if ((not is_logged?) || current_user.is_public?) && @project.is_private?
			flash_msgs(1, "Access denied.")
			redirect_to root_path
		end
	end
	
end
