module SeasonSetup
  class ChapterActivator
    def call
      Chapter
        .where("'#{previous_season}' = ANY(seasons)")
        .where.not("'#{current_season}' = ANY(seasons)")
        .joins(legal_contact: :chapter_affiliation_agreement)
        .includes(legal_contact: :chapter_affiliation_agreement)
        .where(chapter_affiliation_agreement: {status: ["signed", "off-platform"]})
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
