module Ambassador
  class ParticipantsController < AmbassadorController
    def show
      @account = if params[:search_in_region].present?
        Account
          .in_region(current_ambassador)
          .find(params[:id])
      else
        Account
          .joins(:chapterable_assignments)
          .where(
            chapterable_assignments: {
              chapterable_type: current_ambassador.chapterable_type.capitalize,
              chapterable_id: current_ambassador.current_chapterable.id
            }
          )
          .find(params[:id])
      end

      @teams = Team.current.in_region(current_ambassador)
      @season_flag = SeasonFlag.new(@account)
    end
  end
end
