module DataGrids::Ambassador
  class ParticipantsController < AmbassadorController
    include DatagridController

    before_action :ensure_chapterable_country_is_in_ambassadors_country

    layout "ambassador"

    use_datagrid with: AccountsGrid,

      html_scope: ->(scope, user, params) {
        if user.chapter_ambassador_profile&.national_view? &&
            params[:accounts_grid][:chapter].blank? &&
            params[:accounts_grid][:club].blank?
          scope
            .in_region(user.chapterable)
            .page(params[:page])
        else
          scope
            .page(params[:page])
        end
      },

      csv_scope: "->(scope, user, params) {" \
        "if user.chapter_ambassador_profile&.national_view?" \
          "&& params[:chapter].blank?" \
          "&& params[:club].blank?;" \
            "scope.in_region(user.chapterable);" \
        "else;" \
          "scope;" \
        "end;" \
      "}"

    private

    def grid_params
      permitted = permitted_grid_params
      grid = permitted.merge(
        admin: false,
        national_view: current_ambassador.national_view?,
        current_account: current_account,
        allow_state_search: current_ambassador.country_code != "US",
        country: [current_ambassador.country_code],
        state_province: (
          if current_ambassador.country_code == "US"
            [current_ambassador.state_province]
          else
            Array(permitted[:state_province])
          end
        ),
        season: permitted[:season] || Season.current.year,
        season_and_or: permitted[:season_and_or] ||
                         "match_any"
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end

    def ensure_chapterable_country_is_in_ambassadors_country
      chapter_id = params.dig(:accounts_grid, :chapter)
      club_id = params.dig(:accounts_grid, :club)

      if !current_ambassador.national_view? && (chapter_id.present? || club_id.present?)
        raise ActiveRecord::RecordNotFound
      end

      if chapter_id.present?
        chapter = Chapter.find(chapter_id)

        if chapter.country_code != current_ambassador.chapter.country_code
          raise ActiveRecord::RecordNotFound
        end
      end

      if club_id.present?
        club = Club.find(club_id)

        if club.country_code != current_ambassador.chapter.country_code
          raise ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
