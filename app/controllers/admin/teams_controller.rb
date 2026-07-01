module Admin
  class TeamsController < AdminController
    include DatagridController
    include Admin::TeamCreationConcern

    use_datagrid with: TeamsGrid

    def set_semifinalists
      result = Judging::SetContestRankFromCsv.new(
        csv_file: params[:csv_file],
        rank: :semifinalist
      ).call

      redirect_to admin_teams_path,
        success: "Updated #{result.updated_count} submissions to semifinalist."
    rescue Judging::SetContestRankFromCsv::MissingSubmissionIdColumn
      redirect_to admin_teams_path,
        error: 'Please ensure your CSV file contains a "Submission ID" header.'
    end

    def show
      @team = Team.find(params[:id])
    end

    def edit
      @team = Team.find(params[:id])
    end

    def update
      @team = Team.find(params[:id])

      if TeamUpdating.execute(@team, team_params)
        redirect_to admin_team_path, success: "Team changes saved!"
      else
        render :edit
      end
    end

    private

    def team_params
      params.require(:team).permit(
        :name,
        :description,
        :team_photo,
        :city,
        :state_province,
        :country
      )
    end

    def grid_params
      grid = (params[:teams_grid] ||= {}).merge(
        admin: true,
        country: Array(params[:teams_grid][:country]),
        state_province: Array(params[:teams_grid][:state_province]),
        season: params[:teams_grid].present? ? params[:teams_grid][:season] : Season.current.year
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
