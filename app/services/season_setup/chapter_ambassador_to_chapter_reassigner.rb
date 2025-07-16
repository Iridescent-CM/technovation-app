module SeasonSetup
  class ChapterAmbassadorToChapterReassigner
    def call
      chapter_ambassadors.each do |chapter_ambassador|
        next if chapter_ambassador.assigned_to_chapterable?
        next if chapter_ambassador.last_seasons_primary_chapterable_assignment.chapterable.inactive?

        assign_chapter_ambassador_to_last_seasons_chapter(account: chapter_ambassador)
      end
    end

    private

    def chapter_ambassadors
      Account
        .joins(:chapterable_assignments)
        .where(chapterable_assignments: {
          season: last_season,
          profile_type: "ChapterAmbassadorProfile"
        })
    end

    def last_season
      Season.current.year - 1
    end

    def assign_chapter_ambassador_to_last_seasons_chapter(account:)
      account.chapterable_assignments.create(
        profile: account.chapter_ambassador_profile,
        chapterable: account.last_seasons_primary_chapterable_assignment.chapterable,
        season: Season.current.year,
        primary: true
      )
    end
  end
end
