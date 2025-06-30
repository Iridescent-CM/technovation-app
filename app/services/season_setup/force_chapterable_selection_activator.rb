module SeasonSetup
  class ForceChapterableSelectionActivator
    def call
      Account
        .includes(:mentor_profile, :student_profile)
        .where.not(mentor_profiles: {id: nil})
        .or(Account.where.not(student_profiles: {id: nil}))
        .update_all(force_chapterable_selection: true)
    end
  end
end
