module SeasonSetup
  class ClubAmbassadorToClubReassigner
    def call
      club_ambassadors.each do |club_ambassador|
        next if club_ambassador.assigned_to_chapterable?
        next if club_ambassador.last_seasons_primary_chapterable_assignment.chapterable.inactive?

        assign_club_ambassador_to_last_seasons_club(account: club_ambassador)
      end
    end

    private

    def club_ambassadors
      Account
        .joins(:chapterable_assignments)
        .where(chapterable_assignments: {
          season: last_season,
          profile_type: "ClubAmbassadorProfile"
        })
    end

    def last_season
      Season.current.year - 1
    end

    def assign_club_ambassador_to_last_seasons_club(account:)
      account.chapterable_assignments.create(
        profile: account.club_ambassador_profile,
        chapterable: account.last_seasons_primary_chapterable_assignment.chapterable,
        season: Season.current.year,
        primary: true
      )
    end
  end
end
