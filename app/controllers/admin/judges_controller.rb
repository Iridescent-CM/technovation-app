module Admin
  class JudgesController < AdminController
    include DatagridController

    use_datagrid with: JudgesGrid

    def suspend
      judge = JudgeProfile.find(params[:judge_id])
      judge.suspend!
      redirect_back fallback_location: admin_participant_path(judge.account),
        success: "This judge has been suspended."
    end

    def unsuspend
      judge = JudgeProfile.find(params[:judge_id])
      judge.unsuspend!
      redirect_back fallback_location: admin_participant_path(judge.account),
        success: "This judge is no longer suspended."
    end

    private
    def grid_params
      params[:judges_grid] ||= {}
      grid = GridParams.for(params[:judges_grid], current_admin, admin: true)
      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end
  end
end