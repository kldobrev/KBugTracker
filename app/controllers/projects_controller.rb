class ProjectsController < ApplicationController
	
	skip_before_action :require_login, only: [:show, :show_tag]
	before_action :require_proj_access, except: [:new, :create, :show_tag]
	
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
		if @project.update(project_params) && save_tags
			flash_msgs(0, "Project updated successfully.")
			redirect_to @project
		else
			flash_now_msgs(1, @project.errors.full_messages) unless @project.valid?
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
	
	def destroy_tag
		@project = Project.find(params[:id])
		tag = @project.tags.find(params[:tagid])
		if @project.tags.destroy(tag)
			flash_msgs(0, "Tag removed successfully.")
			redirect_to edit_project_path(@project)
		else
			flash_now_msgs(1, "Tag could not be removed. Please try again later.")
			render 'edit'
		end
	end

	def show_tag
		tag = Tag.find(params[:tagid])
		@tag_name = tag.name
		if is_logged? && current_user.is_private?
			@projects = tag.projects.order(prtype: "DESC", created_at: "DESC")
		else
			@projects = tag.projects.where(prtype: 0).order(created_at: "DESC")
		end
	end
	
	private
	
	def project_params
		params.require(:project).permit(:title, :description, :prtype)
	end
	
	def tags_params
		params.permit(tag_names: [])
	end
	
	def save_tags
		tags_params[:tag_names].each do |t_name|
			unless @project.tags.exists?(name: t_name.downcase)
				tag = Tag.find_by(name: t_name.downcase) || Tag.new({name: t_name.downcase})
				unless tag.valid?
					flash_now_msgs(1, tag.errors.full_messages)
					return false
				else
					@project.tags << tag
				end
			end
		end
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
