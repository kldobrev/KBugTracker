class ProjectsController < ApplicationController
	
  skip_before_action :require_login, only: [:show, :show_tag]
  before_action :require_proj_access, except: [:new, :create, :show_tag, :all_editable, :all_owned, :assigned]
  before_action :require_proj_creator, only: [:new, :create]
  before_action :require_owner_permission, except: [:new, :create, :show, :show_tag, :all_editable, :assigned, :show_group, :add_group_member, :remove_group_member, :remove_proj_member, :all_proj_members] 
  before_action :require_admin_access, only: [:all_editable, :remove_proj_member, :add_group_member, :remove_group_member, :all_proj_members]

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

  def assigned
    @user = User.find(params[:usr])
    @projects = @user.members.map {|mem| mem.project}
  end

  def edit
    @project = Project.find(params[:id])
    @pr_groups_num = @project.groups.size
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params) && save_tags && (@project.is_public? || (@project.is_private? && save_group))
      flash_msgs(0, "Project updated successfully.")
      redirect_to @project
    else
      flash_now_msgs(1, @project.errors.full_messages) unless @project.valid?
      render 'edit'
    end
  end

  def destroy
    @project = Project.find(params[:id])
    if @project.is_proj_owner?(current_user) && @project.destroy
      flash_msgs(0, "The project has been deleted.")
    else
      flash_msgs(1, "The project could not be deleted. Please try again.")
    end
    redirect_to user_path(@project.user)
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

  def all_editable 
    @editable = current_user.get_administered + current_user.projects
    @user = User.find(params[:usr])
    respond_to do |format|
      format.html {render layout: false}
    end
  end

  def all_owned
    @owned = current_user.projects
    @user = User.find(params[:usr])
      respond_to do |format|
        format.html {render layout: false}
      end
  end

  def show_group
    @group = Group.find(params[:gr])
  end

  def all_proj_members
    @group = Group.find(params[:gr])
    @project = @group.project
    respond_to do |format|
      format.html {render layout: false}
    end
  end

  def remove_proj_member
    member = Member.find(params[:mem])
    if member.destroy
      flash_msgs(0, "Project member removed successfully.")
    else
      flash_msgs(1, "Project member could not be removed. Please try again later")
    end
    redirect_to project_path(member.project)
  end

  def add_group_member
    gr = Group.find(params[:gr])
    mem = Member.find(params[:mem])
    if gr.members << mem
      flash_msgs(0, "Member added successfully to the group.")
    else
      flash_msgs(1, "Member could not be added. Please try again later.")
    end
    redirect_to group_path(gr.project, gr)
  end

  def remove_group_member
    group = Group.find(params[:gr])
    member = group.members.find(params[:mem])
    if group.members.destroy(member)
      flash_msgs(0, "The member was successfully removed from this group.")
    else
      flash_msgs(1, "The member could not be removed from this group. Please try again later.")
    end
    redirect_to group_path(group.project, group)
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :prtype, groups_attributes: [:id, :name, :_destroy], tags_attributes: [:id, :name, :_destroy])
  end

  def pr_sub_params
    params.permit(:gr_name, :gr_is_admin, tag_names: []) 
  end

  def save_tags
    pr_sub_params[:tag_names].each do |t_name|
      unless t_name.blank? || @project.tags.exists?(name: t_name.downcase)
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

  def save_group
    unless pr_sub_params[:gr_name].blank?
      gr = Group.new(name: pr_sub_params[:gr_name], administrative: pr_sub_params[:gr_is_admin])
      unless gr.valid?
        flash_now_msgs(1, gr.errors.full_messages)
          return false
        else
          @project.groups << gr
        end
    end
    return true
  end
        
  # Denies access for public users to private projects
  def require_proj_access
    if params[:gr]
      @project ||= Group.find(params[:gr]).project
    else
      @project = Project.find(params[:id] || params[:pr])
    end
    if ((not is_logged?) || current_user.is_public?) && @project.is_private?
      flash_msgs(1, "Access denied.")
      redirect_to root_path
    end
  end

  def require_proj_creator
    unless current_user.is_proj_creator?
      flash_msgs(1, "You do not have the required permissions to do that.")
      redirect_to current_user
    end
  end

  def require_owner_permission
    if params[:gr]
      @project ||= Group.find(params[:gr]).project
    elsif params[:id] || params[:pr]
      @project = Project.find(params[:id] || params[:pr])
    end
    unless (params[:usr] && current_user.is_proj_owner?) || @project.is_proj_owner?(current_user)
      flash_msgs(1, "You do not have the required permissions to do that.")
      redirect_to current_user 
    end
  end

  def require_admin_access
    @project = Project.find(params[:pr]) if params[:pr]
    unless ((params[:usr] && (not params[:pr])) && (current_user.is_proj_owner? || current_user.is_admin?)) || @project.is_proj_owner?(current_user) || @project.is_proj_admin?(current_user)
      flash_msgs(1, "You do not have the required permissions to do that.")
      redirect_to project_path(@project)
    end
  end

end

