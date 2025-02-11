module Ambassador
  class ParticipantsController < AmbassadorController
    def show
      if params[:search_in_region].present?
        @account = Account
          .in_region(current_ambassador)
          .find(params[:id])

        @teams = Team
          .current
          .in_region(current_ambassador)
      else
        @account = Account
          .joins(:chapterable_assignments)
          .where(
            chapterable_assignments: {
              chapterable_type: current_ambassador.chapterable_type.capitalize,
              chapterable_id: current_ambassador.current_chapterable.id
            }
          )
          .find(params[:id])

        @teams = Team
          .current
          .by_chapterable(
            current_ambassador.chapterable_type,
            current_ambassador.current_chapterable.id
          )
          .distinct
      end

      @season_flag = SeasonFlag.new(@account)
    end
  end
end
