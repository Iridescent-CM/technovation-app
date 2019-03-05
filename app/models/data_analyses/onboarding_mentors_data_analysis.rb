module DataAnalyses
  class OnboardingMentorsDataAnalysis < DataAnalysis
    def init_data
      if user.is_admin?
        @mentors = Account.current
      else
        @mentors = Account.current
          .in_region(user)
      end

      @onboarded = @mentors.onboarded_mentors
      @not_onboarded = @mentors.onboarding_mentors
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