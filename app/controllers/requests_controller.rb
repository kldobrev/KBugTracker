class RequestsController < ApplicationController

  before_action :require_same_user, only: [:index]
  before_action :require_admin_access, except: [:index, :join_proj, :accept_request]
  before_action :require_proj_owner, only: [:ask_take_ownership]
  before_action :check_crnt_usr_receiver, only: [:accept_request]

  def index 
    @received = current_user.received_requests 
    @created = current_user.made_requests
  end

  def proj_requests
    @project = Project.find(params[:pr])
    @invitations = @project.requests.select {|req| req.is_invitation?}
    @join_req = @project.requests.select {|req| req.is_join_req?}
  end

  def join_proj
    @project = Project.find(params[:pr])
    request = current_user.made_requests.build(to_usr_id: @project.user.id, proj_id: @project.id, req_type: 0)
    if request.save 
      flash_msgs(0, "Request to join project sent successfully.")
    else
      flash_msgs(1, "Could not send the request. Please try again later.")
    end
    redirect_to @project
  end

  def invite_to_proj
    @project = Project.find(params[:pr])
    @user = User.find(params[:usr])
    request = current_user.made_requests.build(to_usr_id: @user.id, proj_id: @project.id, req_type: 1)
    if request.save 
      flash_msgs(0, "Invitation to project sent successfully.")
    else
      flash_msgs(1, "Could not send the request. Please try again later.")
    end
    redirect_to @user
  end

  def ask_take_ownership
    @project = Project.find(params[:pr])
    @user = User.find(params[:usr])
    request = current_user.made_requests.build(to_usr_id: @user.id, proj_id: @project.id, req_type: 2) 
    if request.save
      flash_msgs(0, "Invitation to get ownership sent successfully.")
    else
      flash_msgs(1, "Could not send the request. Please try again later.")
    end
    redirect_to @user
  end

  def accept_request
    request = Request.find(params[:req])
    case request.req_type
      when 0
        add_project_member(request.creator, request.project)
      when 1
        add_project_member(request.receiver, request.project)
      when 2
        change_project_owner(request.receiver, request.project)
    end
    request.destroy
  end

  def destroy
    request = Request.find(params[:req])
    if request.destroy
      flash_msgs(0, "Request deleted successfully")
    else
      flash_msgs(1, "The request could not be deleted. Please try again later.")
    end
    redirect_to all_requests_path(current_user)
  end

  private

  def add_project_member(user, project)
    if (user.acctype == project.prtype) && project.members << user.members.build 
      flash_msgs(0, "User added to project successfully.")
    else
      flash_msgs(1, "The user could not be added. Please try again later.") 
    end
    redirect_to all_requests_path(user) 
  end

  def change_project_owner(user, project)
    project.user = user
    if project.save
      flash_msgs(0, "Project ownership changed successfully.")
    else
      flash_msgs(1, "The request could not be completed. Please try again later.")
    end
    redirect_to all_requests_path(current_user)
  end

  def require_same_user
    user = User.find(params[:usr])
    unless user == current_user
      flash_msgs(1, "Access denied.")
      redirect_to root_path
    end
  end

  def require_admin_access
    if params[:req]
      @req = Request.find(params[:req]) 
      @proj = @req.project
    else
      @proj = Project.find(params[:pr])
    end
    unless current_user == @proj.user || @proj.is_proj_admin?(current_user)
      flash_msgs(1, "Access denied.")
      redirect_to project_path(@proj) 
    end
  end

  def require_proj_owner
    @proj = Project.find(params[:pr])
    unless @proj.is_proj_owner?(current_user)
      flash_msgs(1, "Access denied.")
      redirect_to project_path(@proj) 
    end
  end
  
  def check_crnt_usr_receiver
    request = Request.find(params[:req])
    check_types = [1, 2]
    if check_types.include?(request.req_type) && request.receiver != current_user
      flash_msgs(1, "Access denied.")
      redirect_to project_path(request.project) 
    end
  end

end
