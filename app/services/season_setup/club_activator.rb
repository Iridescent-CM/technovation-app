module SeasonSetup
  class ClubActivator
    def call
      Club
        .where("'#{previous_season}' = ANY(seasons)")
        .where.not("'#{current_season}' = ANY(seasons)")
        .update_all("seasons = array_append(seasons, '#{current_season}')")
    end

    private

    def current_season
      Season.current.year
    end

    def previous_season
      current_season - 1
    end
  end
end
