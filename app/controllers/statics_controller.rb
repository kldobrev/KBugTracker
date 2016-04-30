class StaticsController < ApplicationController

  skip_before_action :require_login, only: [:index, :search]
	
  def index
    if is_logged?
      redirect_to search_path
    else
      redirect_to login_path
    end
  end

  def search
    if params[:search].present?
      sch_pars = params[:search]
      if is_logged?
        if sch_pars[:item] == "1"
          @results_usr = User.search(sch_pars[:username], sch_pars[:firstname], sch_pars[:lastname],
          current_user.is_private? ? sch_pars[:usr_type] : "0")
        else
          @results_pr = Project.search(sch_pars[:query], sch_pars[:sch_descr], 
          current_user.is_private? ? sch_pars[:pr_type] : "0")
        end
      elsif sch_pars[:item].blank? || sch_pars[:item] == "0"
        @results_pr = Project.search(sch_pars[:query], sch_pars[:sch_descr], "0")
      else
        flash_msgs(1, "Illegal search parameters entered.")
        redirect_to root_path
      end
    end
  end

  def guide
  end

  def reccomendations
  end

  def application
  end
	
end

