class DefectsController < ApplicationController

  before_action :get_current_project, except: [:raised_defects, :assigned_defects]
  before_action :require_proj_access, except: [:raised_defects, :assigned_defects]
  before_action :require_defect_involvement, except: [:index, :new, :create, :show, :raised_defects, :assigned_defects]
  before_action :check_is_editable, only: [:edit, :update]
  before_action :check_delete_perm, only: [:destroy]
  before_action :require_same_user, only: [:raised_defects, :assigned_defects]

  def new
    @defect = Defect.new
  end

  def show
    @defect = @project.defects.find(params[:id])
  end

  def index
    @defects = @project.defects
  end

  def edit
    @defect = @project.defects.find(params[:id])
  end

  def create
    @defect = current_user.raised_defs.build(defect_params)
    if @project.defects << @defect
      flash_msgs(0, "Defect raised successfully")
      redirect_to project_defect_path(@project, @defect)
    else
      flash_now_msgs(1, @defect.errors.full_messages)
      render 'new'
    end
  end

  def update
    @defect = @project.defects.find(params[:id])
    if @defect.update(defect_params)
      flash_msgs(0, "Defect updated successfully.")
      redirect_to project_defect_path(@project, @defect)
    else
      flash_now_msgs(1, @defect.errors.full_messages)
      render 'edit'
    end
  end

  def destroy
    @defect = @project.defects.find(params[:id])
    if @defect.destroy
      flash_msgs(0, "The defect was deleted successfully.")
      redirect_to project_path(@project)
    else
      flash_msgs(1, "The defect could not be destroyed. Please try again later.")
      redirect_to project_defect_path(@project, @defect)
    end
  end

  def raised_defects
    @defects = current_user.raised_defs
  end

  def assigned_defects
    @defects = current_user.members.map {|mem| mem.project.defects.select {|df| df.is_assigned_user?(current_user)}}
    @defects.flatten!
  end

  private

  def get_current_project 
    @project = Project.find(params[:project_id])
  end

  def defect_params
    params.require(:defect).permit(:assigned_to_id, :to_group_id, :title, :description, :status, :importance)
  end

  def require_proj_access
    if @project.prtype != current_user.acctype
      flash_msgs(1, "Access denied.")
      redirect_to root_path
    end
  end

  def require_defect_involvement
    @defect = @project.defects.find(params[:id])
    unless @defect.is_assigned_user?(current_user) || @defect.is_def_creator?(current_user) || @project.is_proj_admin?(current_user)
      flash_msgs(1, "Access denied.")
      redirect_to project_defect_path(@project, @defect)
    end
  end

  def check_is_editable
    @defect = @project.defects.find(params[:id])
    unless @defect.is_editable?
      flash_msgs(1, "Access denied.")
      redirect_to project_defect_path(@project, @defect)
    end
  end

  def check_delete_perm
    @defect = @project.defects.find(params[:id])
    unless @defect.has_delete_perm?(current_user)
      flash_msgs(1, "Access denied.")
      redirect_to project_defect_path(@project, @defect)
    end
  end

  def require_same_user
    @user = User.find(params[:usr])
    unless @user == current_user
      flash_msgs(1, "Access denied.")
      redirect_to user_path(current_user)
    end
  end

end

