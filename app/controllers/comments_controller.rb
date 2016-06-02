class CommentsController < ApplicationController

  before_action :get_current_defect, except: [:edit, :update, :destroy]
  before_action :require_proj_access
  before_action :require_edit_perm, only: [:edit, :update]
  before_action :check_if_last, only: [:edit, :update, :destroy]

  def index
    @comments = @defect.comments
    respond_to do |format|
      format.html {render layout: false}
    end
  end

  def new
    @comment = Comment.new
    respond_to do |format|
      format.html {render layout: false}
    end
  end

  def create
    @comment = current_user.comments.build(comment_params)
    if @defect.comments << @comment
      flash_msgs(0, "Comment submitted.")
    else
      flash_msgs(1, @comment.errors.full_messages)
    end
    redirect_to project_defect_path(@defect.project, @defect)
  end

  def edit
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.html {render layout: false}
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      flash_msgs(0, "Comment updated.")
    else
      flash_msgs(1, "The comment could not be updated. Please try again later.")
    end
    redirect_to project_defect_path(@comment.defect.project, @comment.defect)
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash_msgs(0, "Comment deleted.")
    else
      flash_msgs(1, "Comment could not be deleted. Please try again later.")
    end
    redirect_to project_defect_path(@comment.defect.project, @comment.defect)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def get_current_defect
    @defect = Defect.find(params[:defect_id])
  end

  def require_proj_access
    @defect = Comment.find(params[:id]).defect if params[:id]
    if @defect.project.prtype != current_user.acctype
      flash_msgs(1, "Access denied.")
      redirect_to root_path
    end
  end

  def require_edit_perm
    @comment = Comment.find(params[:id])
    unless @comment.user == current_user || @comment.defect.project.is_proj_admin?(current_user)
      flash_msgs(1, "Access denied!")
      redirect_to root_path
    end
  end

  def check_if_last
    @comment = Comment.find(params[:id])
    unless @comment.defect.comments.last == @comment
      flash_msgs(1, "Access denied!")
      redirect_to root_path
    end
  end

end
