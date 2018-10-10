module DataAnalyses
  class OnboardingMentorsDataAnalysis < DataAnalysis
    def init_data
      if user.is_admin?
        @mentors = Account.current
          .left_outer_joins(:mentor_profile)
          .where("mentor_profiles.id IS NOT NULL")
      else
        @mentors = Account.current
          .left_outer_joins(:mentor_profile)
          .where("mentor_profiles.id IS NOT NULL")
          .in_region(user)
      end

      @cleared_mentors = @mentors.bg_check_clear.consent_signed
      @signed_consent_mentors = @mentors.bg_check_submitted.consent_signed
      @cleared_bg_check_mentors = @mentors.bg_check_clear.consent_not_signed
      @neither_mentors = @mentors.bg_check_unsubmitted.consent_not_signed
    end

    def totals
      {
        mentors: number_with_delimiter(@mentors.count),
      }
    end

    def labels
      [
        "Signed consent & cleared a background check, if required – #{show_percentage(@cleared_mentors, @mentors)}",
        "Only signed consent – #{show_percentage(@signed_consent_mentors, @mentors)}",
        "Only cleared bg check, if required – #{show_percentage(@cleared_bg_check_mentors, @mentors)}",
        "Have done neither – #{show_percentage(@neither_mentors, @mentors)}",
      ]
    end

    def data
      [
        @cleared_mentors.count,
        @signed_consent_mentors.count,
        @cleared_bg_check_mentors.count,
        @neither_mentors.count,
      ]
    end

    def urls
      [
        url_helper.public_send("#{user.scope_name}_participants_path",
          accounts_grid: {
            scope_names: ["mentor"],
            background_check: "bg_check_clear",
            consent_waiver: "consent_signed",
          }
        ),

        url_helper.public_send("#{user.scope_name}_participants_path",
          accounts_grid: {
            scope_names: ["mentor"],
            background_check: "bg_check_submitted",
            consent_waiver: "consent_signed",
          }
        ),

        url_helper.public_send("#{user.scope_name}_participants_path",
          accounts_grid: {
            scope_names: ["mentor"],
            background_check: "bg_check_clear",
            consent_waiver: "consent_not_signed",
          }
        ),

        url_helper.public_send("#{user.scope_name}_participants_path",
          accounts_grid: {
            scope_names: ["mentor"],
            background_check: "bg_check_unsubmitted",
            consent_waiver: "consent_not_signed",
          }
        ),
      ]
    end
  end
end