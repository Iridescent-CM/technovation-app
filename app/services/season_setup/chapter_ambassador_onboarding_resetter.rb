module SeasonSetup
  class ChapterAmbassadorOnboardingResetter
    def call
      ChapterAmbassadorProfile
        .update_all(
          training_completed_at: nil,
          viewed_community_connections: false,
          onboarded: false
        )
    end
  end
end
