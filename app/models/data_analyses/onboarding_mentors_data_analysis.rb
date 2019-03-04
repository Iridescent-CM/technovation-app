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

      #FIXME: these queries were cribbed from the datagrid, but should be shared somehow
      @onboarded = @mentors.includes(:background_check, :consent_waiver)
        .references(:background_checks, :consent_waivers)
        .where(
          "email_confirmed_at IS NOT NULL AND " +
          "mentor_profiles.bio IS NOT NULL AND " +
          "(training_completed_at IS NOT NULL OR date(season_registered_at) < ?) AND " +
          "((country = 'US' AND background_checks.status = ?) OR country != 'US')",
          ImportantDates.mentor_training_required_since,
          BackgroundCheck.statuses[:clear]
        )
      @not_onboarded = @mentors.includes(:background_check, :consent_waiver)
        .references(:background_checks, :consent_waivers)
        .where(
          "email_confirmed_at IS NULL OR " +
          "mentor_profiles.bio IS NULL OR " +
          "(training_completed_at IS NULL and date(season_registered_at) >= ?) OR " +
          "(country = 'US' AND (background_checks.status != ? OR background_checks.status IS NULL))",
          ImportantDates.mentor_training_required_since,
          BackgroundCheck.statuses[:clear]
        )
    end

    def totals
      {
        mentors: number_with_delimiter(@mentors.count),
      }
    end

    def labels
      [
        "Fully onboarded - #{show_percentage(@onboarded, @mentors)}",
        "Not fully onboarded - #{show_percentage(@not_onboarded, @mentors)}",
      ]
    end

    def data
      [
        @onboarded.count,
        @not_onboarded.count,
      ]
    end

    def urls
      [
        url_helper.public_send("#{user.scope_name}_participants_path",
          accounts_grid: {
            scope_names: ["mentor"],
            onboarded_mentors: :onboarded,
          }
        ),

        url_helper.public_send("#{user.scope_name}_participants_path",
          accounts_grid: {
            scope_names: ["mentor"],
            onboarded_mentors: :onboarding,
          }
        ),
      ]
    end
  end
end