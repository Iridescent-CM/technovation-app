module Admin
  class JudgesController < AdminController
    include DatagridController

    use_datagrid with: JudgesGrid

    private
    def grid_params
      round = SeasonToggles.current_judging_round(full_name: true)
      round = :quarterfinals if round.to_sym == :off

      grid = (params[:judges_grid] ||= {}).merge(
        admin: true,
        country: Array(params[:judges_grid][:country]),
        state_province: Array(params[:judges_grid][:state_province]),
        current_account: current_account,
        current_judging_round: round,
      )

      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end
  end
end