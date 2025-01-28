module Ambassador
  class ParticipantsController < AmbassadorController
    def show
      @account = Account
        .joins(:chapterable_assignments)
        .where(
          chapterable_assignments: {
            chapterable_type: current_ambassador.chapterable_type.capitalize,
            chapterable_id: current_ambassador.current_chapterable.id
          }
        )
        .find(params[:id])

      @teams = Team.current.in_region(current_ambassador)
      @season_flag = SeasonFlag.new(@account)
    end
  end
end
