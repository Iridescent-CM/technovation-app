module DataAnalyses
  class OnboardingStudentsDataAnalysis < DataAnalysis
    def init_data
      if user.is_admin?
        @students = Account.current
          .left_outer_joins(:student_profile)
          .where("student_profiles.id IS NOT NULL")
      else
        @students = Account.current
          .left_outer_joins(:student_profile)
          .where("student_profiles.id IS NOT NULL")
          .in_region(user)
      end

      @onboarded = @students.where("student_profiles.onboarded = ?", true)
      @not_onboarded = @students.where("student_profiles.onboarded = ?", false)
    end

    def totals
      {
        students: number_with_delimiter(@students.count),
      }
    end

    def labels
      [
        "Fully onboarded - #{show_percentage(@onboarded, @students)}",
        "Not fully onboarded - #{show_percentage(@not_onboarded, @students)}",
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
            scope_names: ["student"],
            onboarded_students: :onboarded,
          }
        ),

        url_helper.public_send("#{user.scope_name}_participants_path",
          accounts_grid: {
            scope_names: ["student"],
            onboarded_students: :onboarding,
          }
        ),
      ]
    end
  end
end