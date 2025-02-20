module Ambassador
  class ParticipantsController < AmbassadorController
    def show
      if current_ambassador.national_view? || params[:search_in_region].present?
        raise ActiveRecord::RecordNotFound if current_ambassador.club_ambassador?

        @account = Account
          .in_region(current_ambassador)
          .find(params[:id])

        raise ActiveRecord::RecordNotFound if params[:search_in_region].present? && @account.is_not_a_judge?

        @teams = Team
          .current
          .in_region(current_ambassador)
      else
        @account = Account
          .by_chapterable(
            current_ambassador.chapterable_type,
            current_ambassador.current_chapterable.id
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
