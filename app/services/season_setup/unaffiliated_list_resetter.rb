module SeasonSetup
  class UnaffiliatedListResetter
    def call
      Account
        .update_all(
          no_chapterable_selected: nil,
          no_chapterables_available: nil
        )
    end
  end
end
