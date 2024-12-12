module ChapterAmbassador
  class ParticipantsController < ChapterAmbassadorController
    include DatagridController

    use_datagrid with: AccountsGrid,

      html_scope: ->(scope, user, params) {
        scope
          .joins(:chapterable_assignments)
          .where(chapterable_assignments: {chapterable_type: "Chapter", chapterable_id: user.current_chapter.id})
          .page(params[:page])
      },

      csv_scope: "->(scope, user, _params) {
        scope
          .joins(:chapterable_assignments)
          .where(chapterable_assignments: {chapterable_type: 'Chapter', chapterable_id: user.current_chapter.id})
      }"

    def show
      @account = if params[:allow_out_of_region]
        Account.find(params[:id])
      else
        Account
          .joins(:chapterable_assignments)
          .where(chapterable_assignments: {chapterable_type: "Chapter", chapterable_id: current_ambassador.current_chapter.id})
          .find(params[:id])
      end

      @teams = Team.current.in_region(current_ambassador)
      @season_flag = SeasonFlag.new(@account)
    end

    private

    def grid_params
      grid = (params[:accounts_grid] ||= {}).merge(
        admin: false,
        allow_state_search: current_ambassador.country_code != "US",
        country: [current_ambassador.country_code],
        state_province: (
          if current_ambassador.country_code == "US"
            [current_ambassador.state_province]
          else
            Array(params[:accounts_grid][:state_province])
          end
        ),
        season: params[:accounts_grid][:season] || Season.current.year,
        season_and_or: params[:accounts_grid][:season_and_or] ||
                         "match_any"
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
