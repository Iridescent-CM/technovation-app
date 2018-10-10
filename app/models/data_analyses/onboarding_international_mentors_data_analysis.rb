module DataAnalyses
  class OnboardingInternationalMentorsDataAnalysis < DataAnalysis
    def init_data
      @mentors = Account.current
        .left_outer_joins(:mentor_profile)
        .where("mentor_profiles.id IS NOT NULL")
        .in_region(user)

      @consenting_mentors = @mentors.eager_load(:consent_waiver)
          .where("consent_waivers.id IS NOT NULL")

      @unconsenting_mentors = @mentors.eager_load(:consent_waiver)
        .where("consent_waivers.id IS NULL")
    end

    def totals
      {
        mentors: number_with_delimiter(@mentors.count),
      }
    end

    def labels
      [
        "Signed consent – #{show_percentage(@consenting_mentors, @mentors)}",
        "Has not signed – #{show_percentage(@unconsenting_mentors, @mentors)}",
      ]
    end

    def data
      [
        @consenting_mentors.count,
        @unconsenting_mentors.count,
      ]
    end

    def urls
      [
        url_helper.regional_ambassador_participants_path(
          accounts_grid: {
            scope_names: ["mentor"],
            consent_waiver: "consent_signed",
          }
        ),

        url_helper.regional_ambassador_participants_path(
          accounts_grid: {
            scope_names: ["mentor"],
            consent_waiver: "consent_not_signed",
          }
        ),
      ]
    end
  end
end